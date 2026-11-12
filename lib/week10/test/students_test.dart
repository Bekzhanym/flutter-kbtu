import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:week10/app.dart';
import 'package:week10/api/fake_api.dart';

Future<void> open(WidgetTester tester, String button) async {
  await tester.pumpWidget(const Shell());
  await tester.tap(find.text(button));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

Future<List<String>> captureLog(Future<void> Function() body) async {
  final log = <String>[];
  final old = debugPrint;
  debugPrint = (m, {wrapWidth}) => log.add(m ?? '');
  try {
    await body();
  } finally {
    debugPrint = old;
  }
  return log;
}

void main() {
  setUp(FakeApi.resetSaves);

  test('FakeApi fails every third fetch and every second save', () async {
    final api = FakeApi();
    expect(await api.fetchStudents(), hasLength(6));
    expect(await api.fetchStudents(), hasLength(6));
    await expectLater(
      api.fetchStudents(),
      throwsA(isA<NoConnectionException>()),
    );
    expect(api.calls, 3);

    await api.save(6);
    await expectLater(api.save(6), throwsStateError);
  });

  testWidgets('By hand: loading → list', (tester) async {
    await open(tester, 'By hand');
    expect(find.text('Loading students…'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    expect(find.text('Aida Nurlanova'), findsOneWidget);
    expect(find.text('—'), findsOneWidget);
  });

  testWidgets('By hand: Back during loading leaves no error', (tester) async {
    await open(tester, 'By hand');
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 2));
    expect(tester.takeException(), isNull);
    expect(find.text('By hand'), findsOneWidget);
  });

  testWidgets('Save: success pops, failure shows SnackBar', (tester) async {
    await open(tester, 'By hand');
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(milliseconds: 500));

    await tester.tap(find.byIcon(Icons.save));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.text('By hand'), findsOneWidget);

    await open(tester, 'By hand');
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.byIcon(Icons.save));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Aida Nurlanova'), findsOneWidget);
    expect(find.text('server rejected 6'), findsOneWidget);
  });

  testWidgets('FutureBuilder: flipping the Switch does not refetch', (
    tester,
  ) async {
    final log = await captureLog(() async {
      await open(tester, 'FutureBuilder');
      await tester.pump(const Duration(seconds: 2));
      expect(find.text('Aida Nurlanova'), findsOneWidget);

      for (var i = 0; i < 10; i++) {
        await tester.tap(find.byType(Switch));
        await tester.pump();
        expect(find.text('Aida Nurlanova'), findsOneWidget);
      }
    });
    expect(log.where((m) => m.startsWith('fetchStudents')), [
      'fetchStudents #1',
    ]);
  });

  testWidgets('Countdown B: leaving at 7 stops the ticks', (tester) async {
    final log = await captureLog(() async {
      await open(tester, 'Countdown');
      await tester.tap(find.text('B · listen'));
      await tester.pump();
      for (var i = 0; i < 4; i++) {
        await tester.pump(const Duration(seconds: 1));
      }
      expect(find.text('7'), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 10));
      expect(tester.takeException(), isNull);
    });
    expect(log.last, 'tick 7');
  });
}
