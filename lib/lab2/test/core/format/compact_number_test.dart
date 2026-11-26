import 'package:flutter_test/flutter_test.dart';
import 'package:trip_planner/core/format/compact_number.dart';

void main() {
  test('compact', () {
    expect(999.compact, '999');
    expect(1500.compact, '1.5K');
    expect(20633529.compact, '20.6M');
    expect(41000000.compact, '41M');
    expect(1400000000.compact, '1.4B');
  });

  test('grouped', () {
    expect(0.grouped, '0');
    expect(999.grouped, '999');
    expect(1000.grouped, '1,000');
    expect(20633529.grouped, '20,633,529');
    expect(2724900.0.grouped, '2,724,900');
    expect((-1234).grouped, '-1,234');
  });
}
