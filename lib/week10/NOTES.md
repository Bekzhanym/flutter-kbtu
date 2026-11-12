# Practice 10 — Notes

## Level 1 — the order of events

Code in `main()` before `runApp`:

```dart
print('A');
Future.delayed(const Duration(seconds: 2), () => print('B'));
print('C');
final api = FakeApi();
api.fetchStudents().then((l) => print('${l.length} students'));
```

**Predicted:** `A`, `C`, `fetchStudents #1`, then the first frame of the app. After about 2 seconds: `B`, then `6 students`.
Nothing waits for the timer. `main()` runs to the end, the event loop draws the frame, and both callbacks arrive later as events.

**Actual** (same code run with plain `dart run`):

```
A
C
fetchStudents #1
fetchStudents #2
fetchStudents #3
end of main
B
Unhandled exception:
Instance of 'NoConnectionException'
```

This matches the prediction. Everything synchronous printed first. `B` printed after 2 s, and the third `fetchStudents()` call (`calls % 3 == 0`) failed with an unhandled exception, because no `.then` and no `try` handles its error.
In Flutter the same thing shows up as `Unhandled Exception: Instance of 'NoConnectionException'` and the app keeps running as if nothing happened. That is the Level 5 problem.

**`sleep` instead of `await Future.delayed`:** `sleep` from `dart:io` blocks the isolate. The app cannot draw its first frame for 2 seconds because the event loop is blocked, not waiting. *(To confirm on a device: `flutter run`.)*

## Level 2 — `mounted`

With both `if (!mounted) return;` lines removed: open "By hand", press Back during the 2 seconds of loading:

```
setState() called after dispose(): _StudentsScreenState#d9fad(lifecycle state: defunct, not mounted)
```

With the guards back in place the console stays clean. The response reaches a State that no longer exists, and `mounted` tells us so.

## Level 3 — FutureBuilder

- `future: _future` (a field): flipping the Switch 10 times prints only one `fetchStudents #1`, and the list never blinks.
- `future: _api.fetchStudents()` inside `build`: every flip creates a new request (`#2 #3 #4 …`), the list is replaced by a spinner, and every third request fails.
- Swapping the `hasError` and `connectionState` branches (`hasData` first, as in the lecture's wrong version) gives a spinner forever when the server is down. A failed Future has no data, so the error never shows.

## Level 4 — countdown

**Version B without `_sub.cancel()`:** Back at 7. One second later:

```
setState() called after dispose(): _ListenCountdownState#215b8(lifecycle state: defunct, not mounted)
```

and the console keeps printing `tick 6`, `tick 5` … `tick 0` while nobody is on screen. That is the leak: the same error as Level 2, delivered a different way.

**Version B with `cancel()`:** Back at 7. The console stops at `tick 7`. The subscription is cancelled, and the generator stops at its next `await`.

**Version A (StreamBuilder):** there is no `cancel()` anywhere in our code, yet the console still stops after Back. StreamBuilder cancels the subscription itself in `dispose`.

## Level 5 — Save

The AI's version: `onPressed: () { _api.save(n); Navigator.pop(context); }`
- `flutter analyze` → `unawaited_futures`: *Missing an 'await' for the 'Future' computed by this expression.*
- The second tap closes the screen as if it succeeded, and the console shows:

```
Unhandled Exception: Bad state: server rejected 6
```

**The user saw a success.**

The honest version: `await` + `try / on StateError` + `context.mounted` after the `await`. The screen pops only on success, and on failure the user gets a SnackBar `server rejected 6`. While the request is in flight the button is disabled and shows a spinner, so two quick taps send one request.

> Note: the save counter in `FakeApi` is `static`. It is "server" state, not one screen's state. Otherwise every newly opened screen would start counting from zero, and the second save would never fail.
