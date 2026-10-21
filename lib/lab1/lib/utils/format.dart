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

String _two(int n) => n.toString().padLeft(2, '0');

String formatTime(DateTime d) => '${_two(d.hour)}:${_two(d.minute)}';

String formatDay(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

String formatDate(DateTime d) =>
    '${d.day} ${_months[d.month - 1]}, ${formatTime(d)}';

String formatDuration(Duration d) {
  if (d.inDays >= 1) return '${d.inDays} d ${d.inHours % 24} h';
  if (d.inHours >= 1) return '${d.inHours} h ${_two(d.inMinutes % 60)} min';
  return '${d.inMinutes} min';
}
