import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/app.dart';
import 'package:trip_planner/core/routes/app_routes.dart';
import 'package:trip_planner/features/countries/repository/fake_country_repository.dart';
import 'package:trip_planner/features/trips/models/trip_model.dart';
import 'package:trip_planner/features/trips/providers/trips_provider.dart';
import 'package:trip_planner/features/trips/repository/fake_trip_repository.dart';

class _Host {
  Trip? result;
  bool closed = false;
}

Future<_Host> _open(
  WidgetTester tester,
  FakeTripRepository repo,
  Object arguments,
) async {
  tester.view.physicalSize = const Size(500, 1400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final host = _Host();
  await tester.pumpWidget(
    ChangeNotifierProvider(
      create: (_) => TripsProvider(repo)..load(),
      child: MaterialApp(
        onGenerateRoute: App.onGenerateRoute,
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              host.result = await Navigator.of(
                context,
              ).pushNamed<Trip>(AppRoutes.tripForm, arguments: arguments);
              host.closed = true;
            },
            child: const Text('open'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  return host;
}

Future<void> _pickDefaultDate(WidgetTester tester, String field) async {
  await tester.tap(find.widgetWithText(TextFormField, field));
  await tester.pumpAndSettle();
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();
}

final _france = fakeCountries.firstWhere((c) => c.alpha3 == 'FRA');

void main() {
  testWidgets('an empty form shows every error and sends nothing', (
    tester,
  ) async {
    final repo = FakeTripRepository();
    await _open(tester, repo, _france);
    final before = repo.calls;

    await tester.tap(find.text('Create trip'));
    await tester.pumpAndSettle();

    expect(find.text('Pick a date'), findsNWidgets(2));
    expect(find.text('Enter a budget'), findsOneWidget);
    expect(repo.calls, before);
  });

  testWidgets('a bad budget is explained beside the field', (tester) async {
    await _open(tester, FakeTripRepository(), _france);
    await tester.enterText(find.widgetWithText(TextFormField, 'Budget'), 'abc');
    await tester.pumpAndSettle();
    expect(find.text('Only digits, e.g. 250000'), findsOneWidget);
  });

  testWidgets('create returns the saved trip through pop', (tester) async {
    final repo = FakeTripRepository();
    final host = await _open(tester, repo, _france);

    await _pickDefaultDate(tester, 'Start date');
    await _pickDefaultDate(tester, 'End date');
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Budget'),
      '900000',
    );
    await tester.tap(find.text('Create trip'));
    await tester.pumpAndSettle();

    expect(host.closed, isTrue);
    expect(host.result?.id, '4');
    expect(host.result?.countryCode, 'FRA');
    expect(host.result?.budget, 900000);
  });

  testWidgets('a double tap on Save sends one request', (tester) async {
    final repo = FakeTripRepository(delay: const Duration(milliseconds: 100));
    await _open(tester, repo, fakeTrips[1]);
    final before = repo.calls;

    await tester.enterText(find.widgetWithText(TextFormField, 'Budget'), '5');
    await tester.tap(find.text('Save changes'));
    await tester.pump(const Duration(milliseconds: 10));
    await tester.tap(find.text('Save changes'), warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(repo.calls - before, 1);
  });

  testWidgets('a clean form leaves without asking', (tester) async {
    final host = await _open(tester, FakeTripRepository(), fakeTrips[1]);
    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('Discard changes?'), findsNothing);
    expect(host.closed, isTrue);
    expect(host.result, isNull);
  });

  testWidgets('a dirty form asks; Cancel stays, Discard leaves', (
    tester,
  ) async {
    final host = await _open(tester, FakeTripRepository(), fakeTrips[1]);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Budget'),
      '777',
    );
    await tester.pump();

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Discard changes?'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(host.closed, isFalse);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Discard'));
    await tester.pumpAndSettle();
    expect(host.closed, isTrue);
    expect(host.result, isNull);
  });

  testWidgets('Save on an edited form leaves without asking', (tester) async {
    final host = await _open(tester, FakeTripRepository(), fakeTrips[1]);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Budget'),
      '777',
    );
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    expect(find.text('Discard changes?'), findsNothing);
    expect(host.result?.budget, 777);
  });
}
