# Language Exchange KBTU

Speaking clubs for KBTU students. Each **meetup** is one evening of practice in one language — English, Kazakh,
Korean, Chinese, Turkish or German — with a fixed number of places. You browse upcoming meetups, open one, see
who is coming and **Join** it; your name goes on its list. Meetups can be in a room or **online**, in which case
the place is a meeting link. Organisers create and edit meetups through one form.

All data lives in memory: twelve seed meetups, dated relative to today, and an empty profile. *Reset data* in the
drawer brings them back.

| Lab part | In this app |
|---|---|
| item | `Meetup` |
| title | 3–60 characters |
| category | `Language` — enhanced enum with `label`, six values |
| when | `startsAt`; a meetup lasts 90 min, then it is past |
| limit | `capacity` |
| the list | `members` (names), count derived |
| mode | `online` — the place becomes a link and must contain `://` |
| optional text | `notes` |
| favourite | ★ on every card |
| primary action | **Join** / **Leave** |

Run with `flutter run` (Flutter 3.47, Dart 3.13). `flutter analyze` → *No issues found!*

## Screenshots

| Phone, light | Phone, dark | Tablet, grid |
|---|---|---|
| ![phone light](screenshots/phone_light.png) | ![phone dark](screenshots/phone_dark.png) | ![tablet](screenshots/tablet.png) |

## Structure

```
lib/
├── main.dart                    MyApp — owns ThemeMode, builds MaterialApp
├── routes.dart                  route names, onGenerateRoute, onUnknownRoute, DetailArgs, FormArgs
├── enums/
│   ├── language.dart            Language: label, colour roles
│   └── meetup_menu_action.dart  Edit / Delete in the detail menu
├── models/
│   ├── meetup.dart              Meetup (immutable), derived getters, sortByDate
│   ├── profile.dart             Profile (name, group)
│   ├── countdown.dart           sealed Countdown: Upcoming / Started / Ended + label
│   └── seed.dart                twelve meetups relative to "now"
├── utils/
│   ├── format.dart              18 Oct, 10:00 · durations — no packages
│   └── keyboard.dart            hideKeyboard for onTapOutside
├── screens/
│   ├── shell_screen.dart        NavigationBar; owns meetups and profile
│   ├── meetups_tab.dart         search, language chips, past filter, list/grid
│   ├── favourites_tab.dart
│   ├── profile_tab.dart         name, group (RegExp), "You are on N lists", theme chips
│   ├── detail_screen.dart       About / Members tabs, minute timer, Join, Edit, Delete
│   ├── meetup_form_screen.dart  new + edit, validators, pickers, PopScope, fake save
│   └── not_found_screen.dart
└── widgets/
    ├── app_drawer.dart          About, Reset data
    ├── app_navigation_bar.dart  Meetups / Favourites / Profile
    ├── confirm_dialog.dart      showConfirmDialog → showDialog<bool>
    ├── empty_state.dart         icon + message + optional button
    ├── meetup_about.dart        language, date, countdown, place, places, notes
    ├── meetup_card.dart         the one card: language tag, FULL / N left, title, date, place, ★
    ├── meetup_collection.dart   ListView.separated or GridView.builder via LayoutBuilder
    ├── members_list.dart        names with "You" highlighted
    ├── tag_label.dart           small coloured label
    └── top_message.dart         text-only message at the top (top_snackbar_flutter)
```

## Decisions

The list of meetups and the profile live in the shell's `State`, the lowest widget that every tab and every
pushed screen can be reached from; the tabs receive them as constructor parameters and report changes through
callbacks, so there is exactly one copy of the data. The detail screen takes callbacks because it changes an
existing meetup in place — join, leave, edit, delete — and the shell must see that while the detail is still
open, whereas the form only produces one finished value, so it returns a `Meetup` through `pop` and the caller
decides what to do with it. The grid is chosen by a `LayoutBuilder` because the collection should react to the
space it was actually given, not to the screen: the same widget works in a tab, a split view or a resized window.
`PopScope` compares a record of every editable value with the record taken when the form opened, so "dirty"
means *different from the start*, not *touched* — typing a letter and deleting it again does not ask. With
week 9's tools I would move the list out of the shell into a repository with persistent storage, so the data
survives a restart and the screens stop passing callbacks through constructors.
