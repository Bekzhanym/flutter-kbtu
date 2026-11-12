import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'models/cart.dart';

void main() => runApp(
  ChangeNotifierProvider(create: (_) => Cart(), child: const Shell()),
);
