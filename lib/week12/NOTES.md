# Practice 12 — Notes

## Level 1 — read a package page in two minutes

Checked on 2026-11-25. Order: publisher → last release → platforms → pub points →
issues vs commits → dependencies → licence.

### Six verdicts

- **shared_preferences** — verified publisher flutter.dev (Flutter Favorite), released October 2026,
  all six platforms, 160/160 points, 16 open issues in flutter/flutter against commits to
  flutter/packages today, depends only on its own platform implementations, BSD-3-Clause.
- **flutter_secure_storage** — verified publisher steenbakker.dev (a community maintainer, not Google),
  released September 2026, all six platforms, 160/160 points, 27 open issues and PRs with a commit today,
  depends only on its own platform implementations and `meta`, BSD-3-Clause.
- **path_provider** — verified publisher flutter.dev (Flutter Favorite), released June 2026,
  five platforms (no web, because the web has no file system), 160/160 points, 22 open issues with
  active commits, depends only on its own platform implementations, BSD-3-Clause.
- **image_picker** — verified publisher flutter.dev, released October 2026, all six platforms,
  160/160 points, 87 open issues (the most of the six, because camera and gallery code differs on every OS)
  with active commits, depends only on its own platform implementations, Apache-2.0 / BSD-3-Clause.
- **permission_handler** — verified publisher baseflow.com (a company), released September 2026,
  four platforms (Android, iOS, Windows, web; no macOS or Linux), 160/160 points, 158 open issues and PRs
  with the last commit on 2026-11-06, depends only on its own platform implementations and `meta`, MIT.
- **url_launcher** — verified publisher flutter.dev (Flutter Favorite), released October 2026,
  all six platforms, 160/160 points, 34 open issues with active commits, depends only on its own
  platform implementations, BSD-3-Clause.

The issues for the flutter.dev packages live in `flutter/flutter`, under the label `p: <package>`, and not in
`flutter/packages`. That is why their counts come from a search.

### What `flutter pub add` wrote

```yaml
shared_preferences: ^2.5.6
flutter_secure_storage: ^11.2.0
path_provider: ^2.1.6
image_picker: ^1.2.4
permission_handler: ^13.0.2
url_launcher: ^6.3.3
```

`pub add` always writes `^` plus the newest version it could resolve.

### The caret

`pubspec.lock` says `http` resolved to exactly **1.6.0**.

`^1.2.0` means `>=1.2.0 <2.0.0`:

- **accepts** 1.2.0, 1.2.1, 1.6.0 and 1.99.3. These are minor and patch releases, and semver promises
  they do not break the API.
- **refuses** 1.1.9 (older than the minimum) and 2.0.0 or newer. A major version is allowed to break
  the API, so pub never moves to it on its own.
- Below 1.0 the caret is stricter: `^0.3.5` means `>=0.3.5 <0.4.0`, because for 0.x versions the
  minor number is the "breaking" one.

### Why `pubspec.lock` is committed for an app

The caret is a range, and the lock is the one exact answer chosen from it, together with sha256 hashes.
Committing the lock means a teammate, the CI and the release build all get the same bytes I tested,
and not whatever was newest on the day they ran `pub get`. A **library** does not commit its lock,
because the app that uses it chooses the versions.

### `flutter pub outdated`

- **cupertino_icons**: we have 1.0.9, and 2.0.0 is out. It was not upgraded because `^1.0.8` refuses a
  new major version. Moving to it is a decision for me to make (`pub upgrade --major-versions`), not
  something pub does on its own.
- **material_color_utilities**: we have 0.13.0, and 0.13.1 is out. It is a transitive dependency, and
  the Flutter SDK itself pins it exactly (`material_color_utilities: 0.13.0` in `packages/flutter/pubspec.yaml`).
  It only moves when Flutter is upgraded.

### Break it on purpose — `http: 1.2.0` (no caret)

Without the caret the constraint is one exact version. In this project it did not even resolve:

```
permission_handler_html >=0.1.3 depends on web >=0.5.1 <2.0.0
http >=1.1.2 <1.2.1 depends on web >=0.3.0 <0.5.0
So, because week12 depends on both http 1.2.0 and permission_handler ^13.0.2, version solving failed.
```

An exact pin cannot bend when another package needs a newer shared dependency (`web`). `pub get` failed,
and the lock stayed at 1.6.0. In a project without permission_handler the lock would drop to exactly
1.2.0, and `pub outdated` would show nothing newer as resolvable. I put the caret back (`^1.6.0`).

## Level 3 — a token that persists safely

### If the token went to `prefs.setString('token', …)`

- **Android**: `/data/data/<applicationId>/shared_prefs/FlutterSharedPreferences.xml`, a plain XML file
  in the app folder. **iOS**: `<app container>/Library/Preferences/<bundle id>.plist`, a plain plist.
- **Who can read it**: anyone with a device backup (an unencrypted Finder/iTunes backup, Android
  backup of app data), anyone with root or a jailbreak, and anyone with a cable and a debuggable build
  (`adb shell run-as <applicationId> cat shared_prefs/FlutterSharedPreferences.xml`).
- So the token goes to `flutter_secure_storage`: the **Keychain** on iOS, and on Android a value
  encrypted with a key that lives in the **Android Keystore**.

### Two platform surprises

- **iOS**: Keychain items are **not deleted when the app is uninstalled**. After a reinstall the old
  token is still there, and the user is "signed in" again. The fix is to keep a first-run flag in
  shared_preferences (which *is* deleted with the app) and clear secure storage when it is missing.
- **Android**: when the user **removes or changes the lock screen**, Keystore keys can be invalidated.
  Old encrypted values can no longer be decrypted and are lost, so a read error must mean "signed out",
  not a crash.

The token is never printed. "Copy token to clipboard" exists only behind `kDebugMode`.

## Level 4 — the offline list

`UsersCache` writes `getApplicationDocumentsDirectory()/users.json`. `getAll()` saves on success and
returns the file on `NoConnectionException`, with `fromCache: true`. With no file it **rethrows**, and the
honest Offline screen appears, not an empty list. Temporary would be wrong: the OS may clear it at any time
("Clear cache"), and the list would vanish silently.

## Level 5 — a photo and a No

### Android (11+)

1. Tap "Take photo" → system dialog → **Don't allow** → `denied`.
2. Tap again → the system asks once more → **Don't allow** → `permanentlyDenied`.
3. Tap a third time → **no system dialog**; our own dialog opens at once → "Open settings" →
   `openAppSettings()` → the app's permission page.

### iOS

- The system asks **only once**. One "Don't Allow" is already final: permission_handler reports
  `permanentlyDenied` after the first refusal, and only Settings can change it.
- The fourth Photos state is **`limited`**: "Select Photos…" (iOS 14+). The user shared some photos,
  not the whole library.
- Without `NSCameraUsageDescription` in Info.plist, iOS kills the app the moment the camera is touched.
  With Swift Package Manager, permission_handler also compiles the camera permission in **only** when
  that key exists.

### Break it on purpose — a link without a scheme

`launchUrl(Uri.parse('kbtu.edu.kz'))` returns **false** and nothing opens, because without `https://`
there is no app for it. With `https://kbtu.edu.kz` the browser opens. Every `launchUrl` result is checked:
`false` → "No app can open this".

### The photo survives a restart

The picked file is copied to `Documents/avatar.jpg`, and the path goes to shared_preferences. On iOS the
container path changes between installs, so `AvatarStore.load()` falls back to `Documents/avatar.jpg`
when the saved path is gone.
