# CLAUDE.md

Guidance for Claude Code when working in this repository.

## Project state

`basecode` is a Flutter starter template **under construction**. Most files under `lib/` are empty
placeholders that express the intended layering. Treat them as a to-do list: fill them in, never delete them.

Files with real content: `lib/core/theme/*`, `lib/core/widgets/buttons/app_button.dart`, and the stock
`lib/main.dart` (counter demo, to be replaced).

Known issues to fix when touching the related code:

- `AppTheme.ThemeDatalight()` is misnamed. Rename it to `AppTheme.light()` (no callers yet).
- `test/widget_test.dart` depends on `MyApp` in `main.dart`. When `main.dart` is replaced, remove or
  rewrite this test in the same change. Never leave a failing test.
- `pubspec.yaml` has no `assets:` section yet. Add one when the first asset is added.
- `env/`, `docs/`, `assets/` are empty.

## Commands

```bash
flutter pub get
flutter run -t lib/main_dev.dart --dart-define-from-file=env/dev.json
flutter run -t lib/main_prod.dart --dart-define-from-file=env/prod.json
flutter analyze
dart format .
flutter test
flutter test test/path/to/file_test.dart
flutter test --name "test name"
```

Flutter 3.47.4 / Dart 3.13.3 (stable). `flutter analyze` covers only `lib/` and `test/`.

**After every change:** run `dart format .`, `flutter analyze`, and `flutter test`. The task is not done
until all three pass.

## Dependency policy (strict)

Prefer the Flutter/Dart SDK. Add a package only when the SDK cannot do the job.

| Level | Source | Rule |
|---|---|---|
| 0 | SDK (`flutter`, `flutter_test`, `flutter_localizations`, `dart:*`) | Always first choice |
| 1 | Verified publisher `dart.dev` / `flutter.dev` | Only if level 0 is not enough |
| 2 | Other publishers | Only if writing it ourselves is risky (security, complex native code) |

- **Never add a package without asking first.** Explain why the SDK is not enough and which level it is.
- Every level-2 package must be recorded with its reason in `docs/DECISIONS.md`.
- No code generation (`build_runner`, freezed, json_serializable, riverpod_generator, etc.).
- Do not use GetX, Riverpod, Bloc, Provider, get_it, dio unless explicitly approved.
- `go_router` **is approved** and already in use. See the routing section below.

Approved stack:

| Need | Solution | Level |
|---|---|---|
| State management | `ChangeNotifier` + `ListenableBuilder` + `Command` (`core/command/`) | 0 |
| Dependency injection | Constructor injection, assembled in `app/dependencies.dart` | 0 |
| Routing | `go_router` (`GoRouter` in `routing/app_router.dart`) | 2 |
| JSON | Manual `fromJson` / `toJson` with Dart 3 pattern matching | 0 |
| Logging | `dart:developer` `log()` wrapped by `core/logger/` | 0 |
| Mocks in tests | Hand-written fakes (`implements`) | 0 |
| HTTP | `http`, wrapped by `core/network/api_client.dart` | 1 |
| Preferences | `shared_preferences` | 1 |
| Localization | `flutter_localizations` + `gen-l10n` + `intl` | 0 / 1 |
| Secure storage (tokens) | `flutter_secure_storage` | 2 |

Only packages actually present in `pubspec.yaml` may be imported. Add them (after approval) before use.

## Architecture: MVVM, feature-first

```
lib/
├── main_dev.dart / main_prod.dart   # only call bootstrap(Flavor.x)
├── app/          # composition root: bootstrap.dart, app.dart, dependencies.dart
├── config/       # flavor.dart, env.dart (only place that reads String.fromEnvironment)
├── routing/      # routes.dart (path constants), app_router.dart
├── core/         # feature-agnostic infrastructure
│   ├── command/  result/  error/  network/  storage/  logger/
│   ├── constants/  extensions/  utils/
│   ├── theme/    # design tokens + AppTheme
│   └── widgets/  # shared widgets (AppButton, ...)
├── shared/<entity>/     # business data used by 2+ features (same shape as a feature)
└── features/<feature>/
    ├── dto/         # wire types: exact API JSON shape, fromJson/toJson, toDomain()
    ├── model/       # domain types used by viewmodel and view (no fromJson)
    ├── service/     # calls endpoints via core/network, returns DTOs, no logic
    ├── repository/  # service → DTO → toDomain() → Result<T>; maps errors to AppException
    ├── viewmodel/   # screen state + actions (ChangeNotifier / Command)
    └── view/        # *_screen.dart, plus widgets/ for feature-only widgets
```

A feature only creates the subfolders it needs (e.g. `profile/` may use `shared/user/` and have no data layer).

### Data flow

```
view → viewmodel → repository → service → core/network
```

### Routing (go_router)

`app/app.dart` uses **`MaterialApp.router` + `routerConfig: appRouter`**. There is no `onGenerateRoute`.

Navigate with go_router extensions on `BuildContext`, never Navigator 1.0:

```dart
import 'package:go_router/go_router.dart';

context.push(AppRoutes.showcaseButton);  // push on top, back button returns
context.go(AppRoutes.dashboard);         // replace the stack
context.pop();                           // back
```

`Navigator.of(context).pushNamed(...)` throws `Navigator.onGenerateRoute was null` in this app — it is
Navigator 1.0 API and `MaterialApp.router` does not set `onGenerateRoute`.

Every route must be registered as a `GoRoute` in `routing/app_router.dart` before anything navigates to it,
and its path always comes from a constant in `routing/routes.dart` (never a raw string).

### Import rules

| From | May import | Must NOT import |
|---|---|---|
| `features/x/view` | own `viewmodel/`, `model/`, `core/`, `routing/routes.dart` | `repository/`, `service/`, `dto/`, other features |
| `features/x/viewmodel` | own `repository/`, `model/`, `shared/*/repository`, `core/` | `package:flutter/material.dart` (use `foundation.dart`), `service/`, `dto/`, widgets |
| `features/x/repository` | own `service/`, `dto/`, `model/`, `core/` | `view/`, `viewmodel/`, Flutter |
| `features/x/service` | own `dto/`, `core/` | `repository/`, `model/`, Flutter UI |
| `features/x` (any) | `core/`, `shared/` | `features/y` |
| `shared/` | `core/` | `features/*` |
| `core/` | nothing from other layers | `shared/`, `features/`, `app/`, `routing/` |
| `routing/` | `features/*/view/`, `core/` | feature `repository/`, `service/`, `dto/` |

Cross-feature navigation uses path constants from `routing/routes.dart`, never direct screen imports
(except inside `app_router.dart`).

### Layer rules

- **Repository** always returns `Result<T>` (`Ok` / `Err`). Never throw to upper layers.
- All transport/platform errors are converted to `AppException` subtypes in `core/error/error_mapper.dart`.
- **DTOs never leave `data` layers** (service/repository). View and viewmodel use domain models only.
- Mapping lives on the DTO as `toDomain()`. No separate `mappers/` folder.
- Repositories are concrete classes. Add an abstract class only when a second real implementation exists.
- **ViewModel** never holds `BuildContext`. Navigation, dialogs, snackbars are triggered in the view by
  listening to viewmodel/command state.
- One viewmodel per screen or meaningful screen section. Split when > ~300 lines or handling unrelated state.
- **Screens that receive a viewmodel are `StatefulWidget` and call `viewModel.dispose()` in `dispose()`.**
- Screen-local UI state (tab index, animation, text controllers) stays in `StatefulWidget` / `setState`.
- `domain` use cases are not used yet. Add `features/<x>/use_case/` only when logic combines 2+ repositories,
  is reused by 2+ viewmodels, or is complex business logic.
- **Rule of two:** code starts inside its feature. Move it to `shared/` only when a second feature needs it.
  Do not import it across features and do not duplicate it.
- `core/` vs `shared/`: if it could be reused in another app unchanged, it belongs in `core/`; if it has
  business meaning for this app, it belongs in `shared/`.
- Token storage lives in `core/storage/` (the network interceptor needs it, and `core/` cannot import features).
- `env/*.json` must never contain secrets; values are extractable from the binary.

## Naming

| Kind | File | Class |
|---|---|---|
| Screen | `login_screen.dart` | `LoginScreen` |
| Feature widget | `login_form.dart` | `LoginForm` |
| ViewModel | `login_view_model.dart` | `LoginViewModel` |
| Repository | `auth_repository.dart` | `AuthRepository` |
| Service | `auth_service.dart` | `AuthService` |
| DTO | `product_dto.dart` | `ProductDto` |
| Domain model | `product.dart` | `Product` (no `Model` suffix) |
| Use case | `checkout_use_case.dart` | `CheckoutUseCase` |

Forbidden suffixes: `Manager`, `Helper`, `Controller`.

## Theming

- `AppTheme` builds light and dark themes from one seed (`AppColors.brand`) via `ColorScheme.fromSeed`, and
  applies one shared `ButtonStyle` (`AppRadius.md` corners) to filled, outlined, and text button themes.
- Tokens live in `core/theme/` (`app_colors.dart`, `app_radius.dart`, ...). Add new tokens there.
- No hardcoded colors, radii, or spacing in features. Use `Theme.of(context).colorScheme` or tokens.

## Shared widgets (`core/widgets/`)

`AppButton` is the reference implementation:

- Wraps Material buttons instead of `InkWell`/`GestureDetector` (keeps ripple, focus, semantics, 48dp target).
  Variants: `primary`/`danger` → `FilledButton`, `secondary` → `FilledButton.tonal`, `outline` →
  `OutlinedButton`, `text` → `TextButton`. Only `danger` overrides colors, resolving disabled states
  against `colorScheme`.
- Sizes are an enhanced enum carrying their own metrics (`height`, `hPadding`, `iconSize`, `gap`).
- `onPressed: null` means disabled. `isLoading` comes from the viewmodel; widgets never own async state.
- Loading keeps the button visually enabled and the same size (label inside `Visibility(maintainSize: true)`
  behind a centered spinner); taps are swallowed via `_noop` + `IgnorePointer`. No layout shift.
- Labels are single-line with ellipsis.

Rules for all shared widgets:

- Features use `AppButton` etc., never raw `FilledButton`/`OutlinedButton`/`TextButton`.
- Icon-only buttons (future `AppIconButton`) require a `tooltip`.
- Every shared widget gets a widget test in `test/core/widgets/`.

Planned order: `AppTextField` → `AppLoadingView` / `AppErrorView` → `AppIconButton` → dialog/snackbar helpers.

## Tests

- `test/` mirrors `lib/`. Fakes live in `test/helpers/fakes/`.
- Required: unit tests for every viewmodel and repository; a parsing test for every DTO using real sample
  JSON from the backend (manual `fromJson` has no compile-time safety).
- ViewModel tests must not need `pumpWidget`. If they do, the layering is broken.

## Style

- Code comments are written in Indonesian. Match the surrounding language when editing.
- Keep changes minimal and scoped to the task. Do not refactor unrelated files.
- Record significant technical decisions in `docs/DECISIONS.md`.