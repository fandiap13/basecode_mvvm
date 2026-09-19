# AGENTS.md

Flutter 3.47.4 / Dart 3.13.3 (stable). Full conventions in `CLAUDE.md` — read it before structural work. This file is the high-signal subset.

## Commands (exact)

```bash
flutter pub get
flutter run -t lib/main_dev.dart --dart-define-from-file=env/dev.json
flutter run -t lib/main_prod.dart --dart-define-from-file=env/prod.json
flutter test test/path/to/file_test.dart   # single file
flutter test --name "test name"             # single test
```

After every change, in order: `dart format .`, then `flutter analyze`, then `flutter test`. All three must pass. `flutter analyze` covers only `lib/` + `test/` (platform dirs excluded in `analysis_options.yaml`).

## Wiring (not obvious from filenames)

- Entrypoints `lib/main*.dart` only call `bootstrap(Flavor.x)` (`app/bootstrap.dart`) → `App` (`app/app.dart`) uses `MaterialApp.router` + `routerConfig: appRouter`. There is no `onGenerateRoute`.
- `config/env.dart` is the only place that may read `String.fromEnvironment`; values come from `--dart-define-from-file=env/*.json`. Never put secrets in `env/*.json` (extractable from binary).
- Most files under `lib/` are empty placeholders expressing intended layering: fill them in, never delete them. `lib/data/` placeholders exist but the intended data layer is per-feature (`dto/`/`service/`/`repository/`); don't build in `lib/data/` without reconciling with `CLAUDE.md` first.
- `docs/`, `assets/` are empty; `pubspec.yaml` has no `assets:` section yet — add it with the first asset.

## Routing (go_router only)

- Navigate with `context.push()` / `context.go()` / `context.pop()`. Never `Navigator.of(...).pushNamed` — it throws (`onGenerateRoute` is null).
- Path always from a constant in `routing/routes.dart`, never a raw string; every route must be a `GoRoute` in `routing/app_router.dart` before navigating to it.
- Gotcha: `routes.dart` declares ~25 showcase paths but `app_router.dart` registers only 6 (initialLocation `/showcase`). Check registration before assuming a path exists.

## Architecture guardrails

- Data flow: `view → viewmodel → repository → service → core/network`. Repository returns `Result<T>` (`Ok`/`Err`), never throws; transport errors become `AppException` in `core/error/error_mapper.dart`. Repositories are concrete classes; add an abstract class only when a second real implementation exists.
- DTOs never leave service/repository; mapping is `toDomain()` on the DTO, no `mappers/` folder. JSON is manual `fromJson`/`toJson` with Dart 3 pattern matching. Views/viewmodels use domain models only.
- State: `ChangeNotifier` + `ListenableBuilder` + `Command` (`core/command/`). DI is constructor injection assembled in `app/dependencies.dart`. Logging is `dart:developer` `log()` wrapped by `core/logger/`.
- ViewModel never holds `BuildContext` and never imports `material.dart` (use `foundation.dart`); navigation/dialogs live in the view. One viewmodel per screen/section (split when > ~300 lines or unrelated state); screen-local UI state (tab index, animation, text controllers) stays in `StatefulWidget`/`setState`. Screens owning a viewmodel are `StatefulWidget` and call `viewModel.dispose()`. Add `features/<x>/use_case/` only when logic combines 2+ repositories, is reused by 2+ viewmodels, or is complex.
- Imports: `features/x/view` may import own `viewmodel/` + `model/` only (never `repository/`/`service/`/`dto/`); `viewmodel` may import own `repository/` + `model/` (never `service/`/`dto/`/widgets); `service` may import own `dto/` only (never `model/`). `features/x` may import `core/` + `shared/`, never `features/y`. `core/` imports nothing from other layers. `shared/` imports only `core/`. Cross-feature navigation via route paths only (except inside `app_router.dart`).
- Rule of two: code starts in its feature; move to `shared/` only when a second feature needs it. `core/` = reusable in another app unchanged; `shared/` = business meaning. Token storage stays in `core/storage/` (network interceptor needs it).
- Naming: `*_screen.dart`/`*Screen`, `*_view_model.dart`/`*ViewModel`, DTO `*_dto.dart`/`*Dto`, domain model has no `Model` suffix. Forbidden suffixes: `Manager`, `Helper`, `Controller`.

## Dependencies (strict — ask first)

SDK first. Never add a package without asking (state why SDK is insufficient + its level). No codegen (`build_runner`, freezed, `json_serializable`, etc.). Banned unless explicitly approved: GetX, Riverpod, Bloc, Provider, `get_it`, `dio`. Only `go_router` is approved and present; `http`, `shared_preferences`, `flutter_secure_storage` are pre-approved candidates — add only after approval and only then import (import only what is in `pubspec.yaml`). Every level-2 publisher package must be recorded with its reason in `docs/DECISIONS.md`.

## UI + tests

- No hardcoded colors/radii/spacing in features — use `Theme.of(context).colorScheme` or `core/theme/` tokens. Features use `AppButton` etc., never raw `FilledButton`/`OutlinedButton`/`TextButton`.
- Shared widgets: `onPressed: null` = disabled; `isLoading` comes from the viewmodel (widgets never own async state) and must not shift layout; icon-only buttons require a `tooltip`. `AppButton` (`core/widgets/button/app_button.dart`) is the reference implementation.
- `test/` mirrors `lib/`; hand-written fakes (`implements`) in `test/helpers/fakes/`, no mock packages. Required: unit test per viewmodel/repository, parsing test per DTO with real sample JSON, widget test per shared widget in `test/core/widgets/`. Viewmodel tests must not need `pumpWidget`.

## Style

- Code comments in Indonesian (match surrounding language). Keep changes minimal and scoped; record significant decisions in `docs/DECISIONS.md`.
