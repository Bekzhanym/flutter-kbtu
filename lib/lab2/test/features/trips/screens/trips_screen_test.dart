import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/app.dart';
import 'package:trip_planner/core/api/api_exception.dart';
import 'package:trip_planner/features/trips/providers/trips_provider.dart';
import 'package:trip_planner/features/trips/repository/fake_trip_repository.dart';
import 'package:trip_planner/features/trips/screens/trips_screen.dart';

Future<void> _pump(
  WidgetTester tester,
  FakeTripRepository repo, {
  VoidCallback? onFind,
}) async {
  await tester.pumpWidget(
    ChangeNotifierProvider(
      create: (_) => TripsProvider(repo)..load(),
      child: MaterialApp(
        home: TripsScreen(onFindCountry: onFind ?? () {}),
        onGenerateRoute: App.onGenerateRoute,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _deleteViaMenu(WidgetTester tester, String country) async {
  await tester.tap(
    find.descendant(
      of: find.widgetWithText(ListTile, country),
      matching: find.byIcon(Icons.more_vert),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text('Delete').last);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('data: trips sorted by country', (tester) async {
    await _pump(tester, FakeTripRepository());
    final names = tester
        .widgetList<ListTile>(find.byType(ListTile))
        .map((t) => ((t.title as Row).children.first as Flexible).child)
        .map((w) => (w as Text).data)
        .toList();
    expect(names, ['Georgia', 'Japan', 'Kazakhstan']);
  });

  testWidgets('error: Retry loads the trips', (tester) async {
    final repo = FakeTripRepository(failWith: const ServerException(503));
    await _pump(tester, repo);
    expect(find.text('Server error (503)'), findsOneWidget);

    repo.failWith = null;
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.text('Japan'), findsOneWidget);
  });

  testWidgets('empty: a sentence and an action', (tester) async {
    var found = false;
    await _pump(
      tester,
      FakeTripRepository(seed: []),
      onFind: () => found = true,
    );
    expect(find.text('No trips yet'), findsOneWidget);
    await tester.tap(find.text('Find a country'));
    expect(found, isTrue);
  });

  testWidgets('delete asks first; Cancel keeps, Delete removes', (
    tester,
  ) async {
    await _pump(tester, FakeTripRepository());

    await _deleteViaMenu(tester, 'Japan');
    expect(find.text('Delete this trip?'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Japan'), findsOneWidget);

    await _deleteViaMenu(tester, 'Japan');
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();
    expect(find.text('Japan'), findsNothing);
    expect(find.text('Trip to Japan deleted.'), findsOneWidget);
  });

  testWidgets('a swipe also asks first', (tester) async {
    await _pump(tester, FakeTripRepository());
    await tester.drag(find.text('Georgia'), const Offset(-500, 0));
    await tester.pumpAndSettle();
    expect(find.text('Delete this trip?'), findsOneWidget);
  });

  testWidgets('the server says no: the trip stays', (tester) async {
    final repo = FakeTripRepository();
    await _pump(tester, repo);
    repo.failWith = const NoConnectionException();

    await _deleteViaMenu(tester, 'Japan');
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Japan'), findsOneWidget);
    expect(find.textContaining('Not deleted.'), findsOneWidget);
  });
}
