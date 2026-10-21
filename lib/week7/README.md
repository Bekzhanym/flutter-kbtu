# Practice 7 — A Form That Validates Itself

Экран регистрации (Sign up), который проверяет себя сам. Ниже — что делалось по шагам и в каком порядке.

Структура:
```
lib/
├── main.dart                  — только main() → runApp(MyApp)
├── app.dart                   — MyApp: MaterialApp + тема
├── data/
│   └── groups.dart            — список групп
├── screens/
│   └── sign_up_screen.dart    — SignUpScreen: форма, State, контроллеры, dispose
├── utils/
│   ├── validators.dart        — функции-валидаторы полей
│   └── date_format.dart       — formatDate → dd.mm.yyyy
└── widgets/
    └── summary_card.dart      — SummaryCard (итоговая карточка)
test/
└── widget_test.dart           — тесты
```
Валидаторы вынесены в отдельный файл как функции, но подключаются всё равно через `validator:`
у каждого поля — правило по-прежнему привязано к своему полю, а не к кнопке.

Запуск: `flutter run`. Проверка: `flutter analyze` → `No issues found!`

---

## Шаг 0. Стартовый код

1. `flutter create week7`.
2. Заменил `lib/main.dart` на стартовый код из задания: `MyApp` с teal-темой, список `groups`,
   `SignUpScreen` (StatefulWidget) и `_SignUpScreenState`.
3. В State уже лежат 4 контроллера (`_name`, `_email`, `_password`, `_confirm`) и `dispose()`,
   который их освобождает. Тело экрана — `Placeholder`.

**Главное правило:** всё, у чего есть `dispose()` (контроллеры, FocusNode), создаётся один раз как поле State
и освобождается в `dispose()`. Никогда не в `build()`.

---

## Шаг 1 (Level 1). Цепочка if

1. `Placeholder` заменил на `Column` из 4 `TextField` (Name, Email, Password, Confirm password) и кнопки
   `FilledButton('Sign up')`.
2. Каждому полю дал контроллер из State и `InputDecoration(labelText: ...)`.
   - Email: `hintText: 'name@kbtu.kz'` — видно, только пока поле пустое.
   - Password: `helperText: 'At least 8 characters'` — серый текст под полем.
   - `labelText` при фокусе поднимается вверх.
3. В кнопке написал цепочку if: имя < 2 → SnackBar «Name is too short» и `return`; нет `@` → «Email looks wrong»;
   пароль < 8 → «Password is too short»; пароли разные → «Passwords do not match»; всё ок → «Account created».
4. У Password добавил `onChanged: (v) => setState(() => _passwordLength = v.length)` и `Text('$_passwordLength of 8')`
   под полем. Цикл: value in → onChanged out → setState замыкает круг.

**Проверка:** на пустой форме — одно сообщение внизу экрана про самое верхнее поле. Чтобы увидеть все 4 ошибки,
нужно 4 нажатия, и ни одна не стоит под своим полем. Это неудобно — поэтому Level 2.

**Ломаем специально:** создал пятый контроллер прямо в `build()` и отдал его полю Name. Ввёл имя, потом
символ в Password → имя пропало. `setState` от счётчика пересобрал экран, и `build()` создал новый пустой
контроллер. Удалил его — вот почему контроллеры живут в State.

---

## Шаг 2 (Level 2). Форма проверяет себя сама

1. Добавил в State `final _formKey = GlobalKey<FormState>();`.
2. Обернул колонку в `Form(key: _formKey)`. Каждому полю дал
   `autovalidateMode: AutovalidateMode.onUserInteraction`.
   > Почему на поле, а не на Form: если поставить режим на `Form`, то после касания **любого** поля
   > Form на каждой перестройке (а `setState` счётчика пароля перестраивает экран на каждый символ)
   > проверяет **все** поля — ввёл букву в Name, и Email/Password/Confirm уже красные.
   > На уровне поля каждое краснеет только после того, как пользователь ввёл что-то именно в него,
   > а все ошибки сразу показывает `validate()` по кнопке Sign up.
3. Все `TextField` → `TextFormField`. **Цепочку if удалил.**
4. Каждому полю дал `validator` (правило стоит рядом с полем, а не в кнопке):
   - Name: `(v ?? '').trim().length < 2` → `'Name is too short'`
   - Email: есть `@` и после него `.` → иначе `'Email looks wrong'`
   - Password: `(v ?? '').length < 8` → `'Password is too short'`
   - Confirm: `v != _password.text` → `'Passwords do not match'` (валидатор читает другой контроллер)
5. Параметр валидатора — `String?`. Null обрабатываю честно: `v ?? ''`, никогда `v!`.
6. Валидатор возвращает `null` = «всё хорошо», строку = «покажи это». `errorText` вручную нигде не задаю,
   красный цвет нигде не упоминается — его рисует тема.
7. Кнопка: `if (_formKey.currentState!.validate())` → SnackBar «Account created».
   Это единственный `!` в проекте — внутри Form, когда она точно построена.

**Проверка:** пустая форма + Sign up → все ошибки сразу, каждая под своим полем. Исправил одно поле —
его ошибка исчезла на следующем символе. Разные пароли → Confirm краснеет сразу, ещё до нажатия.

**Ломаем специально:** `(v) => v.isEmpty ? 'Required' : null` — не компилируется:
*"The getter 'isEmpty' isn't defined for the type 'String?'"*. Вернул честную версию.

---

## Шаг 3 (Level 3). Фокус и клавиатура

1. Email: `keyboardType: TextInputType.emailAddress`, `autocorrect: false`.
2. Оба пароля: `obscureText: true`.
3. `textInputAction: TextInputAction.next` на первых трёх полях, `.done` на последнем.
   У Confirm `onFieldSubmitted: (_) => _submit()` — тот же метод, что у кнопки.
4. Добавил `final _emailFocus = FocusNode();` в State, освобождаю в `dispose()` рядом с контроллерами.
   Name: `onFieldSubmitted: (_) => _emailFocus.requestFocus()` — конкретная цель, а не «следующее».
5. На каждом поле `onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus()` — тап по пустому
   месту прячет клавиатуру. Без GestureDetector.
6. Обернул всё в `SingleChildScrollView(padding: EdgeInsets.all(16))`.
   Перед кнопкой — `SizedBox(height: 24)`, а не `Spacer`.

**Проверка:** тап в Name и 4 раза кнопка действия на клавиатуре: Name → Email → Password → Confirm → submit.
Клавиатура на Confirm — нет жёлто-чёрных полос, кнопку можно доскроллить.

**Ломаем специально:**
- Убрал `SingleChildScrollView` → при открытой клавиатуре полосы overflow (тело сжалось, Column не может).
- `Spacer` вместо `SizedBox` внутри scroll view → красная ошибка «unbounded height».
  Spacer нужен ограниченный родитель, а scroll view им не является. Вернул всё обратно.

---

## Шаг 4 (Level 4). Выбор, а не ввод

1. **Группа:** `DropdownButtonFormField<String>`, пункты через collection for из `groups`,
   `String? _group` в State, `onChanged → setState`, `validator: (g) => g == null ? 'Choose a group' : null`.
   Это FormField, поэтому `validate()` проверяет его вместе с остальными.
2. **Дата рождения:** `TextFormField` с `readOnly: true`, иконкой календаря в `suffixIcon` и отдельным
   контроллером `_birthText`. `onTap` ждёт `showDatePicker(firstDate: DateTime(1950), lastDate: DateTime.now())`.
   Потом три строки:
   ```dart
   if (picked == null) return; // Cancel — старая дата остаётся
   if (!mounted) return;       // экран мог уйти, пока открыт диалог
   setState(() { _birth = picked; _birthText.text = _formatDate(picked); });
   ```
   Формат `dd.mm.yyyy` через `padLeft(2, '0')`. `DateTime? _birth` в State, валидатор проверяет `_birth != null`.
   `_birthText` тоже освобождается в `dispose()`.
3. **Чекбокс:** `CheckboxListTile('I agree to the rules')`, `bool _agreed` в State.
   Кнопка: `onPressed: _agreed ? _submit : null` — при `null` фреймворк сам делает её серой.
   `if (_agreed)` внутри колбэка нет.

**Проверка:** без группы → «Choose a group» под dropdown тем же красным. Выбрал дату, открыл снова, Cancel —
дата осталась. Снял галочку — кнопка серая; поставил — снова активна.

---

## Шаг 5 (Level 5). Итог подстраивается под экран

1. Добавил `bool _done` в State. После успешного Sign up — `setState(() => _done = true)`,
   и `body` показывает `SummaryCard` вместо формы.
2. Создал `lib/widgets/summary_card.dart`: `StatelessWidget` с `const` конструктором и `final` именованными полями
   `name`, `email`, `group`, `birthDate` — по одному `ListTile` на каждое.
3. Внутри `SummaryCard` — `LayoutBuilder`: при `constraints.maxWidth >= 600` плитки в
   `GridView.count(crossAxisCount: 2, shrinkWrap: true, childAspectRatio: 4)`, иначе в `Column`.
   Именно LayoutBuilder, а не MediaQuery: карточка спрашивает про свою коробку, а не про экран.
4. Под карточкой `TextButton('Start over')`: в одном `setState` — `clear()` всех контроллеров,
   `_group = null`, `_birth = null`, `_agreed = false`, `_done = false`.
   Здесь **нельзя** вызывать `_formKey.currentState` — формы нет на экране, он `null`, и `!` бы упал.
5. Финал: `dart format .`, `flutter analyze` → `No issues found!`, все контроллеры и FocusNode освобождены,
   `!` (null-assertion) только в `currentState!` в обработчике Sign up.

**Проверка:** на планшете / при изменении ширины окна через 600 px итог переключается между 1 и 2 колонками.
Start over → сразу Sign up → снова все ошибки, чекбокс снят, кнопка серая.

---

## Тесты

`flutter test`:
- кнопка выключена, пока не поставлена галочка;
- пустая форма показывает все ошибки сразу.

## Скриншоты

Нужно сделать и закоммитить:
- `keyboard_open.png` — форма с открытой клавиатурой на Confirm password, без полос;
- `tablet.png` — итоговая карточка в две колонки.
