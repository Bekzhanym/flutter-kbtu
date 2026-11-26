import 'package:flutter_test/flutter_test.dart';
import 'package:trip_planner/core/format/day_format.dart';

void main() {
  test('dayMonthYear', () {
    expect(DateTime(2026, 12, 1).dayMonthYear, '1 Dec 2026');
  });

  test('a range in one year writes the year once', () {
    expect(
      dayRange(DateTime(2026, 12, 1), DateTime(2026, 12, 3)),
      '1 Dec – 3 Dec 2026',
    );
  });

  test('a range across New Year writes both years', () {
    expect(
      dayRange(DateTime(2026, 12, 28), DateTime(2027, 1, 3)),
      '28 Dec 2026 – 3 Jan 2027',
    );
  });
}
