import 'package:flutter_test/flutter_test.dart';
import 'package:never_overflows/main.dart';

void main() {
  testWidgets('shows the contact list', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Contacts'), findsOneWidget);
    expect(find.text('20 contacts'), findsOneWidget);
    expect(find.text('Aida Akhmetova'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.scrollUntilVisible(find.text('Tomiris Serikbay'), 300);
    await tester.pumpAndSettle();

    expect(find.text('Tomiris Serikbay'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
