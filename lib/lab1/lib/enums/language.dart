import 'package:flutter/material.dart';

enum Language {
  english('English'),
  kazakh('Kazakh'),
  korean('Korean'),
  chinese('Chinese'),
  turkish('Turkish'),
  german('German');

  const Language(this.label);

  final String label;

  Color colorIn(ColorScheme s) => switch (this) {
    Language.english => s.primary,
    Language.kazakh => s.tertiary,
    Language.korean => s.secondary,
    Language.chinese => s.error,
    Language.turkish => s.primaryContainer,
    Language.german => s.tertiaryContainer,
  };

  Color onColorIn(ColorScheme s) => switch (this) {
    Language.english => s.onPrimary,
    Language.kazakh => s.onTertiary,
    Language.korean => s.onSecondary,
    Language.chinese => s.onError,
    Language.turkish => s.onPrimaryContainer,
    Language.german => s.onTertiaryContainer,
  };
}
