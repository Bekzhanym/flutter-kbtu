import 'package:flutter_test/flutter_test.dart';

import 'package:week10/app.dart';

void main() {
  testWidgets('Home screen has three ways in', (tester) async {
    await tester.pumpWidget(const Shell());

    expect(find.text('By hand'), findsOneWidget);
    expect(find.text('FutureBuilder'), findsOneWidget);
    expect(find.text('Countdown'), findsOneWidget);
  });
}
