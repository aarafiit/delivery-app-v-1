# Delivery App — Flutter Customer App

A production-ready Flutter customer app for a multi-role delivery ecosystem (groceries, food, medicine). This repository contains the **Customer App** — one of three clients alongside a Rider App and an Angular Admin Panel. The backend is Spring Boot (REST APIs).

---

## Architecture

The project follows **Clean Architecture** with a strict dependency rule: dependencies point inward only.

```
Presentation  →  Domain  →  Data  →  External APIs
```

| Layer | Responsibility |
|---|---|
| **Presentation** | Widgets, screens, Riverpod state providers/notifiers |
| **Domain** | Entities, use case abstractions (`BaseUseCase`), repository interfaces |
| **Data** | Repository implementations, remote data sources, DTOs (freezed models) |

Each feature is self-contained under `lib/features/<feature_name>/` with its own `data/`, `domain/`, and `presentation/` sub-folders.

---

## Folder Structure

```
lib/
├── config/
│   ├── env/                  # EnvConfig, DevConfig, StagingConfig, ProdConfig
│   ├── routes/               # AppRouter (GoRouter), AppRoutes constants
│   └── theme/                # AppTheme, AppColors, AppTextStyles
│
├── core/
│   ├── error/                # Failure (sealed), ApiException
│   ├── network/              # ApiClient (Dio), AuthInterceptor, LoggingInterceptor, ErrorInterceptor
│   ├── utils/                # ErrorHandler
│   └── widgets/              # AppButton, AppTextField, AppLoader, AppDialog
│
├── features/
│   ├── auth/
│   │   ├── data/             # UserModel (freezed), AuthRemoteDataSource, AuthRepositoryImpl
│   │   ├── domain/           # UserEntity, AuthRepository (abstract), LoginUseCase
│   │   └── presentation/     # authProvider, LoginScreen
│   ├── home/
│   │   └── presentation/     # HomeScreen
│   └── splash/
│       └── presentation/     # SplashScreen
│
├── l10n/                     # ARB files: app_en.arb, app_bn.arb
├── main.dart                 # Production entry point
├── main_dev.dart             # Development entry point
└── main_staging.dart         # Staging entry point
```

---

## Running the App

Install dependencies first:

```bash
flutter pub get
```

### Development

```bash
flutter run -t lib/main_dev.dart
```

Uses `DevConfig` — points to the local/dev backend URL.

### Staging

```bash
flutter run -t lib/main_staging.dart
```

Uses `StagingConfig` — points to the staging backend URL.

### Production

```bash
flutter run -t lib/main.dart
# or simply:
flutter run
```

Uses `ProdConfig` — points to the production backend URL.

### Environment URLs

Update the base URLs in `lib/config/env/`:

| File | Class | Purpose |
|---|---|---|
| `dev_config.dart` | `DevConfig` | Local / development backend |
| `staging_config.dart` | `StagingConfig` | Staging backend |
| `prod_config.dart` | `ProdConfig` | Production backend |

---

## State Management & DI

[Riverpod](https://riverpod.dev/) is used for both state management and dependency injection. The root widget is wrapped in `ProviderScope`. All injectable dependencies (API client, repositories, use cases) are exposed as Riverpod providers.

The active `EnvConfig` is injected at the entry point via `envConfigProvider.overrideWithValue(...)`, so the networking layer automatically picks up the correct base URL.

---

## Navigation

[GoRouter](https://pub.dev/packages/go_router) handles all navigation. Named routes are defined in `lib/config/routes/app_routes.dart`.

| Route | Name | Screen |
|---|---|---|
| `/splash` | `splash` | SplashScreen |
| `/login` | `login` | LoginScreen |
| `/home` | `home` | HomeScreen |

An auth guard stub lives in `AppRouter.redirect` — it currently returns `null` (no redirect). Wire in authentication logic there when the auth feature is complete.

Unknown routes render `NotFoundScreen` (404 fallback).

---

## Adding a New Feature

Follow these steps to add a feature (e.g., `orders`):

1. **Create the folder structure**

```
lib/features/orders/
├── data/
│   ├── datasources/    # OrdersRemoteDataSource
│   ├── models/         # OrderModel (freezed + json_serializable)
│   └── repositories/   # OrdersRepositoryImpl
├── domain/
│   ├── entities/       # OrderEntity
│   ├── repositories/   # OrdersRepository (abstract)
│   └── usecases/       # GetOrdersUseCase, PlaceOrderUseCase
└── presentation/
    ├── providers/       # ordersProvider
    └── screens/         # OrdersScreen
```

2. **Define the domain layer first** — entity, abstract repository, use cases extending `BaseUseCase`.

3. **Implement the data layer** — create a freezed model, a remote data source using `ApiClient`, and a repository implementation.

4. **Register Riverpod providers** in `presentation/providers/` for the repository and use cases.

5. **Add a route** in `lib/config/routes/app_routes.dart` and wire the screen in `lib/config/routes/app_router.dart`.

6. **Add localization strings** to `lib/l10n/app_en.arb` and `lib/l10n/app_bn.arb`, then run:

```bash
flutter gen-l10n
```

7. **Run code generation** if you added freezed models:

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## Code Generation

This project uses `build_runner` for freezed models and JSON serialization:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Run this whenever you add or modify a `@freezed` class or a class annotated with `@JsonSerializable`.

---

## Localization

Supported locales: **English (`en`)** and **Bangla (`bn`)**.

ARB files live in `lib/l10n/`. After editing them, regenerate the localization classes:

```bash
flutter gen-l10n
```

---

## Lint & Analysis

```bash
flutter analyze
```

The project uses [`flutter_lints`](https://pub.dev/packages/flutter_lints). Rules are configured in `analysis_options.yaml`.

---

## Running Tests

```bash
flutter test
```
