const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

extension DayFormat on DateTime {
  String get dayMonthYear => '$day ${_months[month - 1]} $year';

  String get dayMonth => '$day ${_months[month - 1]}';
}

String dayRange(DateTime start, DateTime end) => start.year == end.year
    ? '${start.dayMonth} – ${end.dayMonthYear}'
    : '${start.dayMonthYear} – ${end.dayMonthYear}';
