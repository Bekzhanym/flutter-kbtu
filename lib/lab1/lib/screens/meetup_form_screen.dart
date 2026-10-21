import 'package:flutter/material.dart';

import '../enums/language.dart';
import '../models/meetup.dart';
import '../utils/format.dart';
import '../utils/keyboard.dart';
import '../widgets/confirm_dialog.dart';

class MeetupFormScreen extends StatefulWidget {
  const MeetupFormScreen({super.key, this.initial});

  final Meetup? initial;

  @override
  State<MeetupFormScreen> createState() => _MeetupFormScreenState();
}

class _MeetupFormScreenState extends State<MeetupFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _placeKey = GlobalKey<FormFieldState<String>>();

  late final Meetup _start;
  late final TextEditingController _title;
  late final TextEditingController _place;
  late final TextEditingController _capacity;
  late final TextEditingController _notes;
  late final TextEditingController _date;
  late final TextEditingController _time;

  final _placeFocus = FocusNode();
  final _capacityFocus = FocusNode();
  final _notesFocus = FocusNode();

  Language? _language;
  DateTime? _day;
  TimeOfDay? _timeOfDay;
  late bool _online;
  bool _saving = false;

  late final Object _initial;

  bool get _isNew => widget.initial == null;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _start = initial ?? Meetup.empty();
    _title = TextEditingController(text: _start.title);
    _place = TextEditingController(text: _start.place);
    _capacity = TextEditingController(text: '${_start.capacity}');
    _notes = TextEditingController(text: _start.notes ?? '');
    _date = TextEditingController(
      text: initial == null ? '' : formatDay(initial.startsAt),
    );
    _time = TextEditingController(
      text: initial == null ? '' : formatTime(initial.startsAt),
    );
    _language = initial?.language;
    _day = initial?.startsAt;
    _timeOfDay = initial == null
        ? null
        : TimeOfDay.fromDateTime(initial.startsAt);
    _online = _start.online;
    _initial = _snapshot();
  }

  @override
  void dispose() {
    for (final c in [_title, _place, _capacity, _notes, _date, _time]) {
      c.dispose();
    }
    for (final f in [_placeFocus, _capacityFocus, _notesFocus]) {
      f.dispose();
    }
    super.dispose();
  }

  Object _snapshot() => (
    _title.text,
    _language,
    _date.text,
    _time.text,
    _online,
    _place.text,
    _capacity.text,
    _notes.text,
  );

  bool get _dirty => _snapshot() != _initial;

  DateTime _combine(DateTime day, TimeOfDay time) =>
      DateTime(day.year, day.month, day.day, time.hour, time.minute);

  String? _validateTitle(String? v) {
    final title = (v ?? '').trim();
    if (title.length < 3) return 'At least 3 characters';
    if (title.length > 60) return 'At most 60 characters';
    return null;
  }

  String? _validateLanguage(Language? l) =>
      l == null ? 'Choose a language' : null;

  String? _validateDate(String? _) => _day == null ? 'Pick a date' : null;

  String? _validateTime(String? _) {
    final day = _day;
    final time = _timeOfDay;
    if (time == null) return 'Pick a time';
    if (_isNew && day != null && !_combine(day, time).isAfter(DateTime.now())) {
      return 'A new meetup must be in the future';
    }
    return null;
  }

  String? _validatePlace(String? v) {
    final place = (v ?? '').trim();
    if (place.isEmpty) {
      return _online ? 'A link is required' : 'A room is required';
    }
    if (_online && !place.contains('://')) return 'A link contains ://';
    return null;
  }

  String? _validateCapacity(String? v) {
    final n = int.tryParse((v ?? '').trim());
    if (n == null || n < 1 || n > 500) return 'A whole number from 1 to 500';
    if (n < _start.count) return '${_start.count} people have already joined';
    return null;
  }

  String? _validateNotes(String? v) =>
      (v ?? '').trim().length > 300 ? 'At most 300 characters' : null;

  void _setOnline(bool online) {
    setState(() => _online = online);
    final place = _placeKey.currentState;
    if (place != null && place.hasError) place.validate();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final first = _isNew
        ? DateTime(now.year, now.month, now.day)
        : DateTime(now.year - 1);
    final wanted = _day ?? _start.startsAt;
    final picked = await showDatePicker(
      context: context,
      initialDate: wanted.isBefore(first) ? first : wanted,
      firstDate: first,
      lastDate: DateTime(now.year + 2),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _day = picked;
      _date.text = formatDay(picked);
    });
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _timeOfDay ?? TimeOfDay.fromDateTime(_start.startsAt),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _timeOfDay = picked;
      _time.text = formatTime(_combine(DateTime(2000), picked));
    });
  }

  Future<void> _save() async {
    if (_saving) return;
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    final language = _language;
    final day = _day;
    final time = _timeOfDay;
    if (language == null || day == null || time == null) return;

    final notes = _notes.text.trim();
    final meetup = Meetup(
      id: _isNew ? DateTime.now().microsecondsSinceEpoch.toString() : _start.id,
      title: _title.text.trim(),
      language: language,
      startsAt: _combine(day, time),
      capacity: int.parse(_capacity.text.trim()),
      place: _place.text.trim(),
      members: _start.members,
      online: _online,
      notes: notes.isEmpty ? null : notes,
      favourite: _start.favourite,
    );

    setState(() => _saving = true);
    await Future<void>.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    Navigator.of(context).pop(meetup);
  }

  Future<void> _confirmDiscard(bool didPop, Object? result) async {
    if (didPop || _saving) return;
    final discard = await showConfirmDialog(
      context,
      title: 'Discard changes?',
      message: 'What you typed here will be lost.',
      confirmLabel: 'Discard',
      cancelLabel: 'Keep editing',
    );
    if (!discard || !mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 16);
    const mode = AutovalidateMode.onUserInteraction;

    return PopScope<Meetup>(
      canPop: !_saving && !_dirty,
      onPopInvokedWithResult: _confirmDiscard,
      child: Scaffold(
        appBar: AppBar(title: Text(_isNew ? 'New meetup' : 'Edit meetup')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            onChanged: () => setState(() {}),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _title,
                  maxLength: 60,
                  decoration: const InputDecoration(labelText: 'Title'),
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _placeFocus.requestFocus(),
                  onTapOutside: hideKeyboard,
                  validator: _validateTitle,
                  autovalidateMode: mode,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<Language>(
                  initialValue: _language,
                  decoration: const InputDecoration(labelText: 'Language'),
                  items: [
                    for (final l in Language.values)
                      DropdownMenuItem(value: l, child: Text(l.label)),
                  ],
                  onChanged: (l) => setState(() => _language = l),
                  validator: _validateLanguage,
                  autovalidateMode: mode,
                ),
                gap,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _date,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Date',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        onTap: _pickDate,
                        validator: _validateDate,
                        autovalidateMode: mode,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _time,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Time',
                          suffixIcon: Icon(Icons.schedule),
                        ),
                        onTap: _pickTime,
                        validator: _validateTime,
                        autovalidateMode: mode,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Online meetup'),
                  subtitle: const Text('The place becomes a meeting link'),
                  value: _online,
                  onChanged: _setOnline,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  key: _placeKey,
                  controller: _place,
                  focusNode: _placeFocus,
                  decoration: InputDecoration(
                    labelText: _online ? 'Meeting link' : 'Room',
                    hintText: _online
                        ? 'https://meet.google.com/…'
                        : 'KBTU, Room 412',
                    prefixIcon: Icon(_online ? Icons.link : Icons.place),
                  ),
                  keyboardType: _online
                      ? TextInputType.url
                      : TextInputType.text,
                  autocorrect: !_online,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _capacityFocus.requestFocus(),
                  onTapOutside: hideKeyboard,
                  validator: _validatePlace,
                  autovalidateMode: mode,
                ),
                gap,
                TextFormField(
                  controller: _capacity,
                  focusNode: _capacityFocus,
                  decoration: InputDecoration(
                    labelText: 'Places',
                    helperText: _start.count > 0
                        ? 'From ${_start.count} (already joined) to 500'
                        : 'From 1 to 500',
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _notesFocus.requestFocus(),
                  onTapOutside: hideKeyboard,
                  validator: _validateCapacity,
                  autovalidateMode: mode,
                ),
                gap,
                TextFormField(
                  controller: _notes,
                  focusNode: _notesFocus,
                  decoration: const InputDecoration(
                    labelText: 'About (optional)',
                  ),
                  minLines: 1,
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _save(),
                  onTapOutside: hideKeyboard,
                  validator: _validateNotes,
                  autovalidateMode: mode,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(_isNew ? 'Create' : 'Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
