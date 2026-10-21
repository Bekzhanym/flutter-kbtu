import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:week7/app.dart';

void main() {
  testWidgets('Sign up is disabled until the rules are accepted', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    FilledButton button() => tester.widget(find.byType(FilledButton));
    expect(button().onPressed, isNull);

    await tester.tap(find.byType(CheckboxListTile));
    await tester.pump();
    expect(button().onPressed, isNotNull);
  });

  testWidgets('Empty form shows every error at once', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byType(CheckboxListTile));
    await tester.pump();
    await tester.ensureVisible(find.byType(FilledButton));
    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    expect(find.text('Name is too short'), findsOneWidget);
    expect(find.text('Email looks wrong'), findsOneWidget);
    expect(find.text('Password is too short'), findsOneWidget);
    expect(find.text('Choose a group'), findsOneWidget);
    expect(find.text('Pick your date of birth'), findsOneWidget);
  });
}
