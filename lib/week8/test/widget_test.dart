import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:week8/main.dart';

void main() {
  testWidgets('Filter changes the count in the title', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Reading list (5)'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Unread'));
    await tester.pump();
    expect(find.text('Reading list (4)'), findsOneWidget);

    await tester.tap(find.byType(Checkbox).first);
    await tester.pump();
    expect(find.text('Reading list (3)'), findsOneWidget);
  });

  testWidgets('Empty add form shows three errors', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pump();

    expect(find.text('At least 2 characters'), findsOneWidget);
    expect(find.text('Author is required'), findsOneWidget);
    expect(find.text('A whole number above 0'), findsOneWidget);
    expect(find.textContaining('A year from'), findsNothing);
  });

  testWidgets('Delete asks first and removes the book', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('The Navigator Is a Stack'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(OutlinedButton, 'Delete'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(OutlinedButton, 'Delete'), findsOneWidget);

    await tester.tap(find.widgetWithText(OutlinedButton, 'Delete'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Reading list (4)'), findsOneWidget);
    expect(find.text('The Navigator Is a Stack'), findsNothing);
  });
}
