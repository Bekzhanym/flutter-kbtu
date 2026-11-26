import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:week12/core/errors/api_exception.dart';
import 'package:week12/core/get_it/injection_container.dart';
import 'package:week12/features/users/models/user_model.dart';
import 'package:week12/features/users/repository/user_repository.dart';

const _user1 = r'''
{
  "id": 1,
  "name": "Leanne Graham",
  "username": "Bret",
  "email": "Sincere@april.biz",
  "address": {
    "street": "Kulas Light",
    "suite": "Apt. 556",
    "city": "Gwenborough",
    "zipcode": "92998-3874",
    "geo": {
      "lat": "-37.3159",
      "lng": "81.1496"
    }
  },
  "phone": "1-770-736-8031 x56442",
  "website": "hildegard.org",
  "company": {
    "name": "Romaguera-Crona",
    "catchPhrase": "Multi-layered client-server neural-net",
    "bs": "harness real-time e-markets"
  }
}
''';

Future<void> runChecks() async {
  final user = User.fromJson(jsonDecode(_user1) as Map<String, dynamic>);
  debugPrint('L2 parsed: $user');
  debugPrint('L2 phoneDigits: ${user.phoneDigits}');
  final again = User.fromJson(
    jsonDecode(jsonEncode(user.toJson())) as Map<String, dynamic>,
  );
  debugPrint('L2 round-trip equal: ${again == user}');

  final repo = getIt<UserRepository>();
  try {
    final all = (await repo.getAll()).items;
    debugPrint('L3 getAll: ${all.length} users');
    for (final u in all) {
      debugPrint('  - ${u.name}');
    }

    try {
      await repo.getById(999);
    } on NotFoundException {
      debugPrint('L3 getById(999): not found');
    }

    final created = await repo.create(
      const User.draft(name: 'Test', username: 'test', email: 't@test.kz'),
    );
    debugPrint('L3 create: server assigned id ${created.id}');
  } on ApiException catch (e) {
    debugPrint('L3 failed: $e');
  }
}
