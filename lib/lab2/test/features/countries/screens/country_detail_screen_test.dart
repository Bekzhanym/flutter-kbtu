import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/core/routes/app_routes.dart';
import 'package:trip_planner/features/countries/models/country_model.dart';
import 'package:trip_planner/features/countries/repository/country_repository.dart';
import 'package:trip_planner/features/countries/repository/fake_country_repository.dart';
import 'package:trip_planner/features/countries/screens/country_detail_screen.dart';

Widget _app(FakeCountryRepository repo, Widget home) =>
    Provider<CountryRepository>.value(
      value: repo,
      child: MaterialApp(
        home: home,
        onGenerateRoute: (s) => switch ((s.name, s.arguments)) {
          (AppRoutes.country, final String code) => MaterialPageRoute<void>(
            builder: (_) => CountryDetailScreen(code: code),
          ),
          _ => null,
        },
      ),
    );

Country _kaz() => fakeCountries.firstWhere((c) => c.alpha3 == 'KAZ');

void main() {
  setUp(() {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.physicalSize = const Size(400, 2000);
    view.devicePixelRatio = 1;
  });

  tearDown(
    () => TestWidgetsFlutterBinding.instance.platformDispatcher.views.first
        .reset(),
  );

  testWidgets('preloaded: shows at once, no request', (tester) async {
    final repo = FakeCountryRepository();
    await tester.pumpWidget(
      _app(repo, CountryDetailScreen(code: 'KAZ', preloaded: _kaz())),
    );
    await tester.pumpAndSettle();

    expect(repo.calls, 0);
    expect(find.text('Republic of Kazakhstan'), findsOneWidget);
    expect(find.text('Astana'), findsOneWidget);
    expect(find.text(r'Kazakhstani tenge (₸)'), findsOneWidget);
  });

  testWidgets('by code: loads the country', (tester) async {
    final repo = FakeCountryRepository();
    await tester.pumpWidget(_app(repo, const CountryDetailScreen(code: 'JPN')));
    expect(find.text('Loading country…'), findsOneWidget);

    await tester.pumpAndSettle();
    expect(repo.calls, 1);
    expect(find.text('Tokyo'), findsOneWidget);
  });

  testWidgets('unknown code: NotFound with Retry', (tester) async {
    await tester.pumpWidget(
      _app(FakeCountryRepository(), const CountryDetailScreen(code: 'XXX')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Not found'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('a border chip opens the neighbour', (tester) async {
    final geo = fakeCountries.firstWhere((c) => c.alpha3 == 'GEO');
    await tester.pumpWidget(
      _app(
        FakeCountryRepository(),
        CountryDetailScreen(code: 'GEO', preloaded: geo),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(find.text('TUR'), 200);
    await tester.tap(find.text('TUR'));
    await tester.pumpAndSettle();

    expect(find.text('Republic of Türkiye'), findsOneWidget);
  });

  testWidgets('leaving mid-load is silent', (tester) async {
    final repo = FakeCountryRepository(
      delay: const Duration(milliseconds: 200),
    );
    await tester.pumpWidget(_app(repo, const CountryDetailScreen(code: 'KAZ')));
    await tester.pump(const Duration(milliseconds: 50));

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 300));

    expect(tester.takeException(), isNull);
  });
}
