import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/core/api/api_exception.dart';
import 'package:trip_planner/features/countries/providers/countries_provider.dart';
import 'package:trip_planner/features/countries/repository/fake_country_repository.dart';
import 'package:trip_planner/features/countries/screens/countries_screen.dart';
import 'package:trip_planner/features/countries/widgets/country_card.dart';

Future<FakeCountryRepository> _pump(
  WidgetTester tester, {
  ApiException? failWith,
  Size size = const Size(400, 800),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final repo = FakeCountryRepository(failWith: failWith);
  await tester.pumpWidget(
    ChangeNotifierProvider(
      create: (_) => CountriesProvider(repo)..load(),
      child: const MaterialApp(home: CountriesScreen()),
    ),
  );
  await tester.pumpAndSettle();
  return repo;
}

void main() {
  testWidgets('data: the list shows the countries', (tester) async {
    await _pump(tester);
    expect(find.text('Kazakhstan'), findsOneWidget);
    expect(find.text('Astana · Asia'), findsOneWidget);
  });

  testWidgets('error: NoConnection shows Retry, Retry loads the data', (
    tester,
  ) async {
    final repo = await _pump(
      tester,
      failWith: const NoConnectionException(),
    );
    expect(find.text('No connection'), findsOneWidget);
    expect(find.text('Kazakhstan'), findsNothing);

    repo.failWith = null;
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.text('No connection'), findsNothing);
    expect(find.text('Kazakhstan'), findsOneWidget);
  });

  testWidgets('search is debounced: one request after typing stops', (
    tester,
  ) async {
    final repo = await _pump(tester);
    final before = repo.calls;

    await tester.enterText(find.byType(TextField), 'j');
    await tester.pump(const Duration(milliseconds: 100));
    await tester.enterText(find.byType(TextField), 'ja');
    await tester.pump(const Duration(milliseconds: 100));
    await tester.enterText(find.byType(TextField), 'jap');
    await tester.pump(CountriesScreen.debounce);
    await tester.pumpAndSettle();

    expect(repo.calls - before, 1);
    expect(find.text('Japan'), findsOneWidget);
    expect(find.text('Kazakhstan'), findsNothing);
  });

  testWidgets('empty: no match shows a sentence and an action', (tester) async {
    await _pump(tester);

    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(find.text('Nothing found'), findsOneWidget);

    await tester.tap(find.text('Show all countries'));
    await tester.pumpAndSettle();
    expect(find.text('Kazakhstan'), findsOneWidget);
  });

  testWidgets('600 px and wider: a grid of cards', (tester) async {
    await _pump(tester, size: const Size(800, 800));
    expect(find.byType(CountryCard), findsWidgets);
  });
}
