import 'package:flutter/widgets.dart';

void hideKeyboard(PointerDownEvent _) =>
    FocusManager.instance.primaryFocus?.unfocus();
