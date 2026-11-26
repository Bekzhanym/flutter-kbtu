import 'package:trip_planner/core/json/json_read.dart';
import 'package:trip_planner/features/trips/models/trip_status.dart';

class Trip {
  const Trip({
    required this.id,
    required this.countryCode,
    required this.countryName,
    required this.startDate,
    required this.endDate,
    required this.budget,
    this.notes,
    this.rating,
  });

  const Trip.draft({
    required this.countryCode,
    required this.countryName,
    required this.startDate,
    required this.endDate,
    required this.budget,
    this.notes,
    this.rating,
  }) : id = '';

  factory Trip.fromJson(Map<String, dynamic> json) => Trip(
    id: json.req<String>('id'),
    countryCode: json.req<String>('countryCode'),
    countryName: json.req<String>('countryName'),
    startDate: _day(json.date('startDate')),
    endDate: _day(json.date('endDate')),
    budget: json.dbl('budget'),
    notes: json.opt<String>('notes'),
    rating: json.opt<num>('rating')?.toInt(),
  );

  final String id;

  final String countryCode;

  final String countryName;
  final DateTime startDate;
  final DateTime endDate;
  final double budget;
  final String? notes;

  final int? rating;

  bool get isDraft => id.isEmpty;

  int get days => _utc(endDate).difference(_utc(startDate)).inDays + 1;

  TripStatus statusOn(DateTime today) {
    final t = _utc(today);
    if (t.isBefore(_utc(startDate))) return TripStatus.upcoming;
    if (t.isAfter(_utc(endDate))) return TripStatus.past;
    return TripStatus.ongoing;
  }

  int daysUntil(DateTime today) =>
      _utc(startDate).difference(_utc(today)).inDays;

  Trip copyWith({
    String? id,
    String? countryCode,
    String? countryName,
    DateTime? startDate,
    DateTime? endDate,
    double? budget,
    String? notes,
    int? rating,
  }) => Trip(
    id: id ?? this.id,
    countryCode: countryCode ?? this.countryCode,
    countryName: countryName ?? this.countryName,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    budget: budget ?? this.budget,
    notes: notes ?? this.notes,
    rating: rating ?? this.rating,
  );

  Map<String, dynamic> toJson() => {
    if (!isDraft) 'id': id,
    'countryCode': countryCode,
    'countryName': countryName,
    'startDate': _ymd(startDate),
    'endDate': _ymd(endDate),
    'budget': budget,
    'notes': notes,
    'rating': rating,
  };

  @override
  bool operator ==(Object other) => other is Trip && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Trip#$id($countryCode, ${_ymd(startDate)})';
}

DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

DateTime _utc(DateTime d) => DateTime.utc(d.year, d.month, d.day);

String _ymd(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';
