import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/core/api/api_exception.dart';
import 'package:trip_planner/core/api/api_exception_message.dart';
import 'package:trip_planner/core/format/day_format.dart';
import 'package:trip_planner/core/widgets/confirm_dialog.dart';
import 'package:trip_planner/features/trips/models/trip_model.dart';
import 'package:trip_planner/features/trips/providers/trips_provider.dart';
import 'package:trip_planner/features/trips/validation/trip_validators.dart';
import 'package:trip_planner/features/trips/widgets/date_field.dart';
import 'package:trip_planner/features/trips/widgets/rating_field.dart';
import 'package:trip_planner/features/trips/widgets/save_trip_button.dart';

class TripFormScreen extends StatefulWidget {
  const TripFormScreen({
    super.key,
    this.initial,
    required this.countryCode,
    required this.countryName,
  });

  final Trip? initial;
  final String countryCode;
  final String countryName;

  @override
  State<TripFormScreen> createState() => _TripFormScreenState();
}

class _TripFormScreenState extends State<TripFormScreen> {
  final _form = GlobalKey<FormState>();
  late final _budget = TextEditingController(
    text: _budgetText(_initial?.budget),
  );
  late final _notes = TextEditingController(text: _initial?.notes ?? '');
  late final _startText = TextEditingController(
    text: _initial?.startDate.dayMonthYear ?? '',
  );
  late final _endText = TextEditingController(
    text: _initial?.endDate.dayMonthYear ?? '',
  );
  final _notesFocus = FocusNode();

  late DateTime? _start = _initial?.startDate;
  late DateTime? _end = _initial?.endDate;
  late int? _rating = _initial?.rating;

  Trip? get _initial => widget.initial;
  bool get _isEdit => _initial != null;

  bool get _dirty =>
      _start != _initial?.startDate ||
      _end != _initial?.endDate ||
      _rating != _initial?.rating ||
      _budget.text != _budgetText(_initial?.budget) ||
      _notes.text != (_initial?.notes ?? '');

  static String _budgetText(double? v) => v == null
      ? ''
      : v == v.roundToDouble()
      ? v.toStringAsFixed(0)
      : '$v';

  Future<void> _pickDate({required bool start}) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final current = start ? _start : _end;
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? (start ? today : _start ?? today),
      firstDate: DateTime(today.year - 5),
      lastDate: DateTime(today.year + 5),
    );
    if (picked == null || !mounted) return;
    setState(() {
      if (start) {
        _start = picked;
        _startText.text = picked.dayMonthYear;
      } else {
        _end = picked;
        _endText.text = picked.dayMonthYear;
      }
    });
  }

  Trip? _build() {
    final (start, end) = (_start, _end);
    final budget = TripValidators.parseBudget(_budget.text);
    if (start == null || end == null || budget == null) return null;
    final notes = _notes.text.trim();
    return Trip(
      id: _initial?.id ?? '',
      countryCode: widget.countryCode,
      countryName: widget.countryName,
      startDate: start,
      endDate: end,
      budget: budget,
      notes: notes.isEmpty ? null : notes,
      rating: _rating,
    );
  }

  Future<void> _save() async {
    final valid = _form.currentState?.validate() ?? false;
    final trip = _build();
    if (!valid || trip == null) return;
    final trips = context.read<TripsProvider>();
    try {
      final saved = _isEdit
          ? await trips.update(trip)
          : await trips.create(trip);
      if (!mounted) return;
      Navigator.of(context).pop(saved);
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Not saved. ${e.message}')));
    }
  }

  Future<void> _onPop(bool didPop, Trip? result) async {
    if (didPop) return;
    final leave = await showConfirmDialog(
      context,
      title: 'Discard changes?',
      message: 'What you changed in this trip will be lost.',
      confirmLabel: 'Discard',
    );
    if (leave && mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _budget.dispose();
    _notes.dispose();
    _startText.dispose();
    _endText.dispose();
    _notesFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_budget, _notes]),
      builder: (context, _) => PopScope<Trip>(
        canPop: !_dirty,
        onPopInvokedWithResult: _onPop,
        child: Scaffold(
          appBar: AppBar(title: Text(_isEdit ? 'Edit trip' : 'New trip')),
          body: Form(
            key: _form,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              padding: const EdgeInsets.all(16),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(child: Text(widget.countryCode)),
                  title: Text(widget.countryName),
                  subtitle: const Text('Country'),
                ),
                const SizedBox(height: 16),
                ..._dateFields(),
                const SizedBox(height: 16),
                _budgetField(),
                const SizedBox(height: 16),
                RatingField(
                  value: _rating,
                  onChanged: (v) => setState(() => _rating = v),
                ),
                const SizedBox(height: 16),
                _notesField(),
                const SizedBox(height: 24),
                SaveTripButton(
                  label: _isEdit ? 'Save changes' : 'Create trip',
                  onSave: _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _dateFields() => [
    DateField(
      label: 'Start date',
      controller: _startText,
      value: _start,
      onTap: () => _pickDate(start: true),
    ),
    const SizedBox(height: 16),
    DateField(
      label: 'End date',
      controller: _endText,
      value: _end,
      onTap: () => _pickDate(start: false),
    ),
  ];

  Widget _budgetField() => TextFormField(
    controller: _budget,
    validator: TripValidators.budget,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    textInputAction: TextInputAction.next,
    onFieldSubmitted: (_) => _notesFocus.requestFocus(),
    onTapOutside: (_) => FocusScope.of(context).unfocus(),
    decoration: const InputDecoration(
      labelText: 'Budget',
      prefixIcon: Icon(Icons.payments_outlined),
      border: OutlineInputBorder(),
    ),
  );

  Widget _notesField() => TextFormField(
    controller: _notes,
    focusNode: _notesFocus,
    validator: TripValidators.notes,
    maxLines: 4,
    maxLength: TripValidators.notesMax,
    textInputAction: TextInputAction.done,
    onTapOutside: (_) => FocusScope.of(context).unfocus(),
    decoration: const InputDecoration(
      labelText: 'Notes',
      alignLabelWithHint: true,
      border: OutlineInputBorder(),
    ),
  );
}
