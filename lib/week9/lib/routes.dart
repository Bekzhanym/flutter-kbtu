import 'package:flutter/material.dart';

import 'screens/books_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/not_found_screen.dart';

abstract final class Routes {
  static const home = '/';
  static const cartScreen = '/cart';

  static final Map<String, WidgetBuilder> table = {
    home: (_) => const BooksScreen(),
    cartScreen: (_) => const CartScreen(),
  };

  static Route<dynamic> onUnknownRoute(RouteSettings settings) =>
      MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => NotFoundScreen(name: settings.name),
      );
}
