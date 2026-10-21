# Practice 8 — A Little of Everything

Повторение недель 1–7 в одном маленьком приложении «Reading list»: список книг с фильтром,
экран деталей (прочитано / удалить) и форма добавления книги. Ниже — что делалось по шагам.

Структура (шесть файлов по заданию):
```
lib/
├── main.dart              — debugPrint перед runApp, MyApp (MaterialApp + тема indigo)
├── models/
│   ├── book.dart          — Book, Book.fromMap, toString, totalPages / unread / authors, seed
│   ├── filter.dart        — enum Filter { all, unread, read }
│   └── book_action.dart   — enum BookAction { toggleRead, delete }
├── widgets/
│   └── book_tile.dart     — BookTile: карточка книги в списке
├── library_screen.dart    — LibraryScreen: список, фильтр, шапка со статистикой, FAB
├── detail_screen.dart     — DetailScreen + enum BookAction
└── add_book_screen.dart   — AddBookScreen: форма с валидацией
test/
├── book_test.dart         — тесты модели (чистый Dart)
└── widget_test.dart       — тесты экранов
```

Запуск: `flutter run`. Проверка: `flutter analyze` → `No issues found!`, `flutter test`.

---

## Шаг 0. Стартовый код

1. Проект создан через `flutter create week8`.
2. В `lib/main.dart` вставил стартовый код: `MyApp` с indigo-темой, класс `Book` и список `seed`.
   `library_screen.dart` пока не существует — код не компилируется, это ожидаемо.

---

## Шаг 1 (Level 1). Dart без виджетов

1. Перенёс `Book` и `seed` в `lib/models/book.dart`. Этот файл **ничего не импортирует из Flutter** —
   это чистый Dart.
2. Добавил именованный конструктор `Book.fromMap(Map<String, dynamic> m)`:
   ```dart
   Book.fromMap(Map<String, dynamic> m)
     : title = m['title'] as String,
       author = m['author'] as String,
       pages = m['pages'] as int,
       year = m['year'] as int?,            // нет ключа → null
       read = m['read'] as bool? ?? false;  // нет ключа → false
   ```
   Ни одного `!`.
3. `toString()` → `Null Safety for Humans — B. Seitkali, 196 pp. (2022)`.
   Если `year == null`, скобок нет совсем — один `?:` по nullable-полю:
   ```dart
   final y = year;
   return '$title — $author, $pages pp.${y == null ? '' : ' ($y)'}';
   ```
4. Три функции верхнего уровня в том же файле:
   - `totalPages` — через `fold(0, (sum, b) => sum + b.pages)`;
   - `unread` — через `where((b) => !b.read).toList()`;
   - `authors` — через `map((b) => b.author).toSet().toList()` (без дублей, порядок сохраняется).
5. В `main()` перед `runApp` — два `debugPrint`.

**Проверка:** в консоли
```
1220 pages, 4 unread
X — Y, 10 pp.
```
Без скобок и без `null`. То же самое проверяет `test/book_test.dart`.

**Ломаем специально:** `final int? year` → `final int year`. Компилятор ругается на `seed`
(у книги нет года), на `fromMap` (`as int?` не подходит к `int`) и на `toString`. Вернул `?`.

---

## Шаг 2 (Level 2). Список, который реагирует

1. Создал `lib/library_screen.dart` — `StatefulWidget`. Его State хранит список и фильтр:
   - `final List<Book> _books = [...seed];` — копия списка, сам `seed` не трогаем;
   - `enum Filter { all, unread, read }` над классом, `Filter _filter = Filter.all;`.
2. Геттер `_visible` — switch-выражение:
   ```dart
   List<Book> get _visible => switch (_filter) {
     Filter.all => _books,
     Filter.unread => unread(_books),          // функция из Level 1
     Filter.read => _books.where((b) => b.read).toList(),
   };
   ```
3. Над списком `Row` из трёх `ChoiceChip` (All / Unread / Read): `selected: _filter == f`,
   `onSelected → setState`.
4. Ниже — `Expanded(ListView.builder(...))` по `_visible`. На этом шаге для каждой книги был
   `CheckboxListTile` с `onChanged: (v) => setState(() => book.read = v ?? false)`.
5. В заголовке AppBar — `'Reading list (${_visible.length})'`, число меняется вместе с фильтром.

**Проверка:** на Unread отметил книгу — она пропала, число в заголовке уменьшилось на 1.
На All снова 5. Чип остаётся выбранным, галочки запоминаются.

**Ломаем специально:** `book.read = v ?? false` без `setState` — по нажатию ничего не меняется.
Значение поменялось, но экран никто не перестроил. Вернул `setState`.

---

## Шаг 3 (Level 3). Вёрстка, которая не ломается

1. Создал `lib/widgets/book_tile.dart` — `BookTile` (StatelessWidget, const-конструктор,
   `final Book book`, `final VoidCallback onToggle`, плюс `onTap` для перехода на Level 4).
   В списке заменил `CheckboxListTile` на `BookTile`.
2. Устройство `BookTile`:
   ```
   Card → Padding(12) → Row
     ├── Stack: CircleAvatar (первая буква) + Positioned-точка справа сверху, если книга не прочитана
     ├── SizedBox(width: 12)
     ├── Expanded → Column(start)
     │     ├── title  (titleMedium, maxLines: 2, ellipsis)
     │     └── "author · 196 pp."
     └── Checkbox → onToggle
   ```
3. Шапка над чипами: `Card` → `Row` из трёх `Expanded` колонок — Books, Pages, Unread.
   Число в `headlineSmall`, подпись в `bodySmall`. Значения из функций Level 1:
   `_books.length`, `totalPages(_books)`, `unread(_books).length`.
4. Все цвета берутся из `Theme.of(context).colorScheme`, все стили текста — из `textTheme`.
   В `book_tile.dart` нет ни `Colors.*`, ни `fontSize:`.

**Проверка:** длинное название занимает 2 строки и заканчивается на «…», жёлто-чёрных полос нет,
чекбоксы во всех строках на одной вертикали. Отметил книгу — точка пропала, Unread в шапке уменьшился.

**Ломаем специально:** убрал `Expanded` вокруг `Column` → полосы и «overflowed by N pixels»:
Row дал колонке неограниченную ширину, и текст занял её всю. Вернул `Expanded`.
При повороте экрана три колонки шапки делят ширину поровну — это тоже работа `Expanded`.

---

## Шаг 4 (Level 4). Экран, который отвечает

1. Создал `lib/detail_screen.dart` — `DetailScreen`, StatelessWidget. Книгу получает через конструктор.
   Показывает все поля; если `year == null`, пишет **Year unknown**. Стрелку «назад» рисует сам AppBar —
   нет ни `BackButton`, ни `leading:`.
2. В этом же файле `enum BookAction { toggleRead, delete }`.
3. Кнопки:
   - «Mark as read» / «Mark as unread» (подпись зависит от `book.read`) → `pop(BookAction.toggleRead)`;
   - «Delete» → сначала спрашивает:
     ```dart
     final confirmed = await showDialog<bool>(... AlertDialog("Delete 'title'?") Cancel / Delete ...);
     if (confirmed != true) return;      // Cancel или тап мимо → null/false
     if (!context.mounted) return;       // между await и pop
     Navigator.of(context).pop(BookAction.delete);
     ```
4. Со стороны списка:
   ```dart
   final action = await Navigator.of(context).push<BookAction>(MaterialPageRoute(...));
   if (!mounted) return;
   switch (action) {
     case null: return;                                         // назад — ничего не меняем
     case BookAction.toggleRead: setState(() => book.read = !book.read);
     case BookAction.delete: setState(() => _books.remove(book));
   }
   ```
   Экран деталей **никогда не трогает `_books`** — он только отвечает.

**Стек:** list → detail → dialog. Диалог возвращает `bool`, детали возвращают `BookAction`,
а список всё это время лежит снизу и ждёт.

**Проверка:** назад — ничего не поменялось. Delete → Cancel — остаёмся на деталях.
Delete → Delete — вернулись в список, книги нет, Books в шапке уменьшилось на 1.
Mark as read — в списке стоит галочка.

---

## Шаг 5 (Level 5). Форма с валидацией

1. Создал `lib/add_book_screen.dart` — `AddBookScreen`. На списке появилась `FloatingActionButton`,
   которая открывает форму через `push<Book>`.
2. В State: `GlobalKey<FormState>` и четыре контроллера (title, author, pages, year). Все они
   освобождаются в `dispose()`.
3. У каждого поля свой валидатор:
   - Title: минимум 2 символа после `trim()`;
   - Author: не пустой;
   - Pages: `final n = int.tryParse(v ?? ''); if (n == null || n <= 0) return 'A whole number above 0';`
   - Year: пусто — можно, иначе число от 1450 до `DateTime.now().year`.
4. `keyboardType: TextInputType.number` у pages и year; `next` у первых трёх полей, `done` у последнего
   (оно вызывает Save); `onTapOutside` прячет клавиатуру; `Column` внутри `SingleChildScrollView`.
5. `autovalidateMode: onUserInteraction` стоит **на каждом поле**, а не на `Form`, — по той же причине,
   что и в week7: если поставить его на `Form`, то после ввода в одно поле красными становятся все.
6. Save:
   ```dart
   if (_formKey.currentState!.validate()) {
     final book = Book(
       title: _title.text.trim(),
       author: _author.text.trim(),
       pages: int.parse(_pages.text.trim()),   // безопасно: валидатор уже проверил
       year: int.tryParse(_year.text.trim()),  // '' → null = «год неизвестен»
     );
     Navigator.of(context).pop(book);
   }
   ```
7. Список: `await push<Book>` → `if (!mounted) return;` → `if (book == null) return;` →
   `setState(() => _books.add(book))`.
8. `dart format .`, `flutter analyze` → `No issues found!`. Null-assertion `!` есть только
   в `currentState!` в Save (остальные `!` в коде — это логическое «не»).

**Проверка:** Save на пустой форме — три ошибки сразу (год без ошибки). Pages = `abc` — ошибка,
форма не закрывается. Пустой год — сохраняется, в деталях «Year unknown». В списке новая книга,
не прочитана; Books, Pages и Unread в шапке выросли. Назад из формы — ничего не добавилось,
ничего не упало (вернулся `null`).

---

## Тесты

`flutter test` — 7 тестов:
- модель: `1220` страниц, `4` непрочитанных, `X — Y, 10 pp.`, `toString` с годом, `authors` без дублей;
- фильтр меняет число в заголовке, а галочка в Unread убирает книгу;
- пустая форма показывает три ошибки, ошибки года нет;
- Delete спрашивает подтверждение, Cancel оставляет на экране, Delete удаляет книгу.

## Скриншоты

Нужно сделать и закоммитить:
- `screenshot_list.png` — фильтр Unread, длинное название в две строки;
- `screenshot_form.png` — форма с тремя ошибками.
