# week10 — The Data Arrives Later

Practice 10: a fake API, four states by hand, FutureBuilder, a countdown with Stream, and errors that do not vanish.

## Structure

```
lib/
  main.dart                 runApp(Shell)
  app.dart                  MaterialApp + routes
  routes.dart               named routes: / , /by-hand, /future, /countdown
  api/
    fake_api.dart           FakeApi (2 s, fails every 3rd fetch / every 2nd save)
    countdown.dart          Stream<int> countdown(int from) async*
  models/
    student.dart            Student + seedStudents
  screens/
    home_screen.dart        By hand / FutureBuilder / Countdown
    students_screen.dart    Level 2 (3 fields, mounted) + Level 5 (Save)
    students_future_screen.dart   Level 3 (Future in a field, Switch)
    countdown_screen.dart   Level 4 (A: StreamBuilder, B: listen + cancel)
    not_found_screen.dart
  widgets/
    loading_view.dart  error_view.dart  empty_view.dart  student_list.dart
    stream_countdown.dart  listen_countdown.dart
```

## Run

```
flutter run
flutter analyze   # No issues found! (unawaited_futures: true)
flutter test
```

Observations are in [NOTES.md](NOTES.md).
