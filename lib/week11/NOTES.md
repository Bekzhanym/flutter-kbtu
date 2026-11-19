# Practice 11 — Notes

## Level 1 — the wire, before any Dart

### `GET /users` and `GET /users/1`

- Status **200**, `Content-Type: application/json; charset=utf-8`
- `/users` is a JSON **array** of **10** users. `/users/1` is a single **object**.
- Nested objects: `address` and `company`. Nested twice: `address.geo`.
- `geo.lat` / `geo.lng` are **strings** (`"-37.3159"`), not numbers. The model has to `double.parse` them.
- All 10 users have every field. Nothing is `null` or missing in the real data. `website` is the one field we
  treat as optional (`String?`). It is the field most likely to be missing for a real person.
- `company.bs` exists, but the app does not use it. The `company` record keeps only `name` and `catchPhrase`.

### User (top level)

| field      | JSON type | Dart type                              | nullable? |
|------------|-----------|----------------------------------------|-----------|
| `id`       | number    | `int`                                  | no        |
| `name`     | string    | `String`                               | no        |
| `username` | string    | `String`                               | no        |
| `email`    | string    | `String`                               | no        |
| `address`  | object    | `Address`                              | no        |
| `phone`    | string    | `String` (+ getter `phoneDigits`)      | no        |
| `website`  | string    | `String?`                              | **yes**   |
| `company`  | object    | `({String name, String catchPhrase})`  | no        |

### `address`

| field     | JSON type | Dart type | nullable? |
|-----------|-----------|-----------|-----------|
| `street`  | string    | `String`  | no        |
| `suite`   | string    | `String`  | no        |
| `city`    | string    | `String`  | no        |
| `zipcode` | string    | `String`  | no        |
| `geo`     | object    | `Geo`     | no        |

### `address.geo`

| field | JSON type             | Dart type                 | nullable? |
|-------|-----------------------|---------------------------|-----------|
| `lat` | **string** (a number) | `double` via `double.parse` | no      |
| `lng` | **string** (a number) | `double` via `double.parse` | no      |

### `company`

| field         | JSON type | Dart type              | nullable? |
|---------------|-----------|------------------------|-----------|
| `name`        | string    | `String`               | no        |
| `catchPhrase` | string    | `String`               | no        |
| `bs`          | string    | not used, dropped      | no        |

### `GET /users/999`

- Status **404**, `Content-Type: application/json`, body **`{}`** (an empty object, not an error message).
- Mapped in `_check`: 404 → `NotFoundException`.
- If `_check` forgets 404, `_decode` succeeds on `{}` and `fromJson` throws on `id` (`null` is not an `int`).
  The error becomes `BadResponseException('users/999: type 'Null' is not a subtype of type 'int'…')`. It is
  still our exception, but it names the wrong cause. That is why the status is checked before the body.

### `POST /users` with `Content-Type: application/json`

```
→ {"name":"Bekzhan","username":"bek","email":"bek@example.com"}
← 201 Created
  Location: https://jsonplaceholder.typicode.com/users/11
  {"name":"Bekzhan","username":"bek","email":"bek@example.com","id":11}
```

- Status **201**. The server echoes back what was sent and adds **`id: 11`** (and a `Location` header).
- Nothing is actually saved. `GET /users/11` is still 404.
- The server echoes only what it was sent, so the app POSTs the full `toJson()` shape (empty address and company).
  That way `User.fromJson` can read the answer.

### `GET /users?id=3`

- Status 200. The answer is a **list of one** `[ { "id": 3, … } ]`, not an object.
- In Dart: `Uri.https(host, '/users', {'id': '3'})`.

### Status → exception (used in `ApiClient._check`)

| status                       | exception                         |
|------------------------------|-----------------------------------|
| no response / timeout        | `NoConnectionException`           |
| 401                          | `UnauthorizedException`           |
| 404                          | `NotFoundException`               |
| ≥ 500                        | `ServerException(status)`         |
| not the expected 200/201     | `BadResponseException`            |
| body not JSON / bad cast     | `BadResponseException`            |

## Level 2 — model checks (`flutter run --dart-define=CHECKS=true`)

```
L2 parsed: User#1(Leanne Graham, @Bret, Gwenborough)  geo=(-37.3159, 81.1496)
L2 phoneDigits: 1770736803156442
L2 round-trip equal: true
```

Broken on purpose:
- `json['lat'] as double` → `type 'String' is not a subtype of type 'double' in type cast`.
- `"id": "1"` in the pasted JSON → `type 'String' is not a subtype of type 'int' in type cast`.
  Both errors name the field. In the repository they become `BadResponseException`.

## Level 3 — repository checks

```
L3 getAll: 10 users
  - Leanne Graham … Clementina DuBuque
L3 getById(999): not found
L3 create: server assigned id 11
```

`grep -rn "package:http" lib/` finds only `lib/core/network/api_client.dart`. It is the only class that knows http.
`UserRepository` asks `ApiClient` for JSON and turns it into models. Screens get models or an `ApiException`.
`http.Client` is created once, in `core/get_it/injection_container.dart` (registered through get_it).

## Level 4 — the chain

- Removing the `BadResponseException()` arm from the switch in `features/users/screens/users_screen.dart` gives a compile error:
  *The type 'ApiException?' is not exhaustively matched by the switch cases…*
- Host typo `jsonplaceholder.typicode.co` → `SocketException` (failed host lookup) → `NoConnectionException`.
  The Offline view appears in under a second. After the host is fixed, Retry loads the list without a restart.

## Level 5 — two kinds of "no network"

| test                                      | what happens                             | time to Offline view |
|-------------------------------------------|------------------------------------------|----------------------|
| Airplane mode, pull to refresh            | `SocketException` right away             | **TODO: measure** (< 1 s expected) |
| Wi-Fi hotspot with no internet behind it  | packets go out and never come back → `TimeoutException` | **TODO: measure** (~10 s expected) |

Screenshots: `screenshot_timeout.png` (DevTools → Network, `/users` with no status, ~10 000 ms) and
`screenshot_200.png` (a 200 row with its body open).

POST from the UI: Save is disabled while the request is in flight (`_saving`). A double tap sends one
request. DevTools → Network shows one `POST /users` with status **201**.
