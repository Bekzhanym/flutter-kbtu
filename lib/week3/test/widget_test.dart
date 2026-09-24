import 'package:flutter_test/flutter_test.dart';
import 'package:week3/main.dart';

void main() {
  testWidgets('Profile screen shows name and facts', (tester) async {
    await tester.pumpWidget(const ProfileApp());

    expect(find.text('My profile'), findsOneWidget);
    expect(find.text('Bekzhan'), findsOneWidget);
    expect(find.text('Course'), findsOneWidget);
    expect(find.text('Padding'), findsOneWidget);
  });
}
