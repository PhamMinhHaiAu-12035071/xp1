# Source Tree Architecture

## Overview

This document defines the project folder structure for the **XP1** Flutter application, a brownfield project that implements Clean Architecture principles with Domain-Driven Design (DDD) patterns. The structure supports modular development, clear separation of concerns, and follows Flutter/Dart best practices.

## Project Structure Principles

1. **Clean Architecture Layers**: Clear separation between Domain, Application, Infrastructure, and Presentation layers
2. **Feature-Based Organization**: Related functionality grouped by business domain
3. **Modular Design**: Each feature is self-contained with its own architectural layers
4. **Testability**: Mirror structure in test directory for comprehensive coverage
5. **Bootstrap Pattern**: Centralized application initialization with phase-based startup
6. **Environment Management**: Multi-environment configuration with type safety

## Complete Source Tree

```
xp1/
├── android/                           # Android platform-specific code
├── ios/                              # iOS platform-specific code
├── macos/                            # macOS platform-specific code
├── web/                              # Web platform-specific code
├── windows/                          # Windows platform-specific code
│
├── lib/                              # Main Dart source code
│   ├── main_development.dart         # Development environment entry point
│   ├── main_staging.dart             # Staging environment entry point
│   ├── main_production.dart          # Production environment entry point
│   ├── bootstrap.dart                # Application bootstrap coordination
│   │
│   ├── app/                          # Application layer
│   │   ├── app.dart                  # Main app widget export
│   │   └── view/
│   │       └── app.dart              # Root application widget
│   │
│   ├── core/                         # Core/Shared infrastructure
│   │   ├── assets/                   # Asset management
│   │   │   ├── app_icons.dart        # Icon abstractions
│   │   │   ├── app_icons_impl.dart   # Icon implementations
│   │   │   ├── app_images.dart       # Image abstractions
│   │   │   └── app_images_impl.dart  # Image implementations
│   │   │
│   │   ├── bootstrap/                # Application startup orchestration
│   │   │   ├── app_bootstrap.dart    # Main bootstrap coordinator
│   │   │   ├── dependency_bootstrap.dart   # Legacy bootstrap (deprecated)
│   │   │   ├── error_handling_bootstrap.dart # Legacy error setup
│   │   │   ├── locale_bootstrap.dart # Legacy locale setup
│   │   │   ├── interfaces/
│   │   │   │   └── bootstrap_phase.dart # Bootstrap phase contract
│   │   │   ├── orchestrator/
│   │   │   │   └── bootstrap_orchestrator.dart # Chain of responsibility orchestrator
│   │   │   └── phases/               # Modular bootstrap phases
│   │   │       ├── dependency_injection_phase.dart
│   │   │       ├── error_handling_phase.dart
│   │   │       └── locale_bootstrap_phase.dart
│   │   │
│   │   ├── constants/                # Application-wide constants
│   │   │   ├── app_constants.dart    # General app constants
│   │   │   └── route_constants.dart  # Navigation route definitions
│   │   │
│   │   ├── di/                       # Dependency injection setup
│   │   │   ├── injection_container.dart    # GetIt service locator
│   │   │   ├── injection_container.config.dart # Generated configuration
│   │   │   └── app_module.dart       # Module definitions
│   │   │
│   │   ├── domain/                   # Core domain services
│   │   │   ├── exceptions/
│   │   │   │   └── locale_exceptions.dart
│   │   │   └── services/
│   │   │
│   │   ├── guards/                   # Route protection
│   │   │   └── auth_guard.dart       # Authentication guard
│   │   │
│   │   ├── infrastructure/           # Core infrastructure services
│   │   │   ├── bloc/
│   │   │   │   └── app_bloc_observer.dart # Global BLoC observer
│   │   │   ├── locale/               # Locale infrastructure
│   │   │   └── logging/              # Logging services
│   │   │       ├── i_logger_service.dart   # Logger interface
│   │   │       └── logger_service.dart     # Logger implementation
│   │   │
│   │   ├── mappers/                  # Data transformation utilities
│   │   │   └── base_mapper.dart      # Base mapper pattern
│   │   │
│   │   ├── network/                  # Network infrastructure
│   │   │   └── api_client.dart       # HTTP client configuration
│   │   │
│   │   ├── platform/                 # Platform detection
│   │   │   └── platform_detector.dart
│   │   │
│   │   ├── providers/                # State providers
│   │   │
│   │   ├── routing/                  # Navigation management
│   │   │   ├── app_router.dart       # AutoRoute configuration
│   │   │   └── app_router.gr.dart    # Generated routes
│   │   │
│   │   ├── security/                 # Security services
│   │   │   └── jwt_service.dart      # JWT token management
│   │   │
│   │   ├── services/                 # Core application services
│   │   │   ├── asset_image_service.dart      # Image service interface
│   │   │   ├── asset_image_service_impl.dart # Image service implementation
│   │   │   ├── svg_icon_service.dart         # SVG service interface
│   │   │   └── svg_icon_service_impl.dart    # SVG service implementation
│   │   │
│   │   ├── sizes/                    # Responsive design utilities
│   │   │   ├── app_sizes.dart        # Size abstractions
│   │   │   └── app_sizes_impl.dart   # Size implementations
│   │   │
│   │   ├── storage/                  # Data persistence
│   │   │   └── secure_storage_service.dart # Secure storage wrapper
│   │   │
│   │   ├── styles/                   # Design system
│   │   │   ├── app_text_styles.dart          # Text style abstractions
│   │   │   ├── app_text_styles_impl.dart     # Text style implementations
│   │   │   └── colors/
│   │   │       ├── app_colors.dart           # Color abstractions
│   │   │       └── app_colors_impl.dart      # Color implementations
│   │   │
│   │   ├── themes/                   # Theme management
│   │   │   ├── app_theme.dart        # Main theme configuration
│   │   │   └── extensions/
│   │   │       ├── app_color_extension.dart  # Color theme extensions
│   │   │       └── app_theme_extension.dart  # Theme extensions
│   │   │
│   │   ├── utils/                    # Utility functions
│   │   │   ├── locale_utils.dart     # Locale utilities interface
│   │   │   ├── locale_utils_stub.dart # Stub implementation
│   │   │   └── locale_utils_web.dart  # Web-specific implementation
│   │   │
│   │   └── widgets/                  # Reusable core widgets
│   │       ├── responsive_initializer.dart # Responsive setup widget
│   │       └── widgets.dart          # Widget exports
│   │
│   ├── features/                     # Feature modules (business domains)
│   │   ├── attendance/               # Attendance tracking feature
│   │   │   └── presentation/
│   │   │       └── pages/
│   │   │           └── attendance_page.dart
│   │   │
│   │   ├── authentication/           # Authentication feature (Clean Architecture)
│   │   │   ├── application/          # Application layer - Use cases & BLoCs
│   │   │   │   └── blocs/
│   │   │   │       ├── auth_bloc.dart
│   │   │   │       ├── auth_event.dart
│   │   │   │       ├── auth_event.freezed.dart
│   │   │   │       ├── auth_state.dart
│   │   │   │       └── auth_state.freezed.dart
│   │   │   ├── domain/               # Domain layer - Entities, repos, use cases
│   │   │   │   ├── entities/         # Business entities
│   │   │   │   ├── failures/         # Domain failures
│   │   │   │   ├── inputs/           # Value objects/inputs
│   │   │   │   ├── repositories/     # Repository contracts
│   │   │   │   │   └── auth_repository.dart
│   │   │   │   └── usecases/         # Business use cases
│   │   │   ├── infrastructure/       # Infrastructure layer - External concerns
│   │   │   │   ├── mappers/          # Data transformation
│   │   │   │   ├── models/           # Data models/DTOs
│   │   │   │   ├── repositories/     # Repository implementations
│   │   │   │   └── services/         # External service integrations
│   │   │   └── presentation/         # Presentation layer - UI components
│   │   │       ├── pages/
│   │   │       └── widgets/
│   │   │
│   │   ├── env/                      # Environment configuration feature
│   │   │   ├── development.env       # Development environment variables
│   │   │   ├── development.env.example
│   │   │   ├── production.env        # Production environment variables
│   │   │   ├── production.env.example
│   │   │   ├── staging.env           # Staging environment variables
│   │   │   ├── staging.env.example
│   │   │   ├── domain/
│   │   │   │   └── env_config_repository.dart
│   │   │   ├── infrastructure/
│   │   │   │   ├── env_config_factory.dart    # Environment factory
│   │   │   │   └── env_config_repository_impl.dart
│   │   │   ├── env_development.dart  # Development config class
│   │   │   ├── env_development.g.dart # Generated development config
│   │   │   ├── env_production.dart   # Production config class
│   │   │   ├── env_production.g.dart # Generated production config
│   │   │   ├── env_staging.dart      # Staging config class
│   │   │   └── env_staging.g.dart    # Generated staging config
│   │   │
│   │   ├── features/                 # Generic features page
│   │   │   └── presentation/
│   │   │       └── pages/
│   │   │
│   │   ├── home/                     # Home feature
│   │   │   └── presentation/
│   │   │       └── pages/
│   │   │
│   │   ├── locale/                   # Internationalization feature
│   │   │   ├── application/
│   │   │   │   └── locale_application_service.dart
│   │   │   ├── cubit/
│   │   │   │   └── locale_cubit.dart
│   │   │   ├── di/
│   │   │   │   └── locale_module.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   ├── errors/
│   │   │   │   ├── repositories/
│   │   │   │   └── services/
│   │   │   └── infrastructure/
│   │   │       ├── default_platform_locale_provider.dart
│   │   │       └── shared_preferences_locale_repository.dart
│   │   │
│   │   ├── main_navigation/          # Bottom navigation feature
│   │   │   └── presentation/
│   │   │       └── pages/
│   │   │           └── main_wrapper_page.dart
│   │   │
│   │   ├── profile/                  # User profile feature
│   │   │   └── presentation/
│   │   │       └── pages/
│   │   │
│   │   ├── splash/                   # Splash screen feature
│   │   │   └── presentation/
│   │   │       ├── cubit/            # Splash state management
│   │   │       ├── pages/
│   │   │       │   └── splash_page.dart
│   │   │       └── widgets/          # Splash-specific widgets
│   │   │
│   │   └── statistics/               # Statistics feature
│   │       └── presentation/
│   │           └── pages/
│   │
│   ├── l10n/                         # Localization files
│   │   ├── gen/                      # Generated localization files
│   │   │   ├── strings.g.dart        # Main generated translations
│   │   │   ├── strings_en.g.dart     # English translations
│   │   │   └── strings_vi.g.dart     # Vietnamese translations
│   │   ├── i18n/                     # Translation source files
│   │   │   ├── en.i18n.json          # English translation keys
│   │   │   ├── vi.i18n.json          # Vietnamese translation keys
│   │   │   ├── strings.g.dart        # Generated (duplicate)
│   │   │   ├── strings_en.g.dart     # Generated (duplicate)
│   │   │   └── strings_vi.g.dart     # Generated (duplicate)
│   │   └── l10n.dart                 # Localization configuration
│   │
│   └── shared/                       # Shared utilities (future expansion)
│
├── test/                             # Test files (mirrors lib/ structure)
│   ├── core/
│   │   ├── security/                 # Core security tests
│   │   └── storage/                  # Core storage tests
│   └── features/
│       └── authentication/          # Authentication feature tests
│           ├── application/          # Application layer tests
│           ├── domain/               # Domain layer tests
│           └── infrastructure/       # Infrastructure layer tests
│
├── docs/                             # Project documentation
│   ├── architecture/                 # Architecture documentation
│   │   ├── coding-standards.md       # Development standards
│   │   ├── tech-stack.md             # Technology stack documentation
│   │   └── source-tree.md            # This document
│   ├── qa/                           # Quality assurance documentation
│   │   ├── assessments/              # Risk assessments
│   │   └── gates/                    # Quality gates
│   ├── stories/                      # User stories and requirements
│   ├── authentication-integration-prd.md # Auth integration requirements
│   └── brownfield-architecture.md   # Brownfield architecture overview
│
├── .bmad-core/                       # BMAD methodology configuration
│   ├── agents/                       # AI agent configurations
│   ├── checklists/                   # Development checklists
│   ├── data/                         # Knowledge base and preferences
│   ├── tasks/                        # Automated task definitions
│   ├── templates/                    # Document templates
│   └── core-config.yaml              # Core BMAD configuration
│
├── analysis_options.yaml             # Dart/Flutter linting rules
├── pubspec.yaml                      # Package dependencies and metadata
├── pubspec.lock                      # Locked dependency versions
├── lefthook.yml                      # Git hooks configuration
├── Makefile                          # Build automation scripts
├── rps.yaml                          # Development scripts configuration
├── README.md                         # Project overview and setup
└── CLAUDE.md                         # Development guidelines for Claude
```

## Key Architectural Patterns

### 1. Clean Architecture Implementation

Each feature module follows Clean Architecture with clear layer separation:

- **Domain Layer** (`features/*/domain/`): Business logic, entities, repository contracts
- **Application Layer** (`features/*/application/`): Use cases, BLoCs, application services
- **Infrastructure Layer** (`features/*/infrastructure/`): External concerns, data sources, repository implementations
- **Presentation Layer** (`features/*/presentation/`): UI components, pages, widgets

### 2. Bootstrap Architecture

The application uses a sophisticated bootstrap system:

- **Phase-Based Initialization**: Modular startup phases with dependency management
- **Chain of Responsibility**: Bootstrap orchestrator coordinates initialization phases
- **Error Handling**: Robust error handling with rollback capabilities
- **Environment Awareness**: Different initialization for development/staging/production

### 3. Environment Management

Multi-environment support with type safety:

- **Environment Files**: Separate `.env` files for each environment
- **Generated Configuration**: Type-safe environment classes with code generation
- **Factory Pattern**: Environment-specific configuration creation
- **Build-Time Selection**: Environment selection at compile time

### 4. Feature Organization

Features are organized as self-contained modules:

- **Domain-Driven Design**: Features align with business domains
- **Vertical Slicing**: Each feature contains all necessary layers
- **Clear Boundaries**: Minimal coupling between features
- **Independent Testing**: Each feature can be tested in isolation

## Directory Conventions

### File Naming

- **Dart Files**: `snake_case.dart`
- **Class Names**: `PascalCase`
- **Constants**: `SCREAMING_SNAKE_CASE`
- **Private Members**: `_leadingUnderscore`

### Feature Structure

All features should follow this structure when implementing Clean Architecture:

```
feature_name/
├── application/          # Application layer (optional for simple features)
│   ├── blocs/           # BLoC state management
│   ├── cubits/          # Cubit state management (alternative to BLoC)
│   └── services/        # Application services
├── domain/              # Domain layer (required for complex features)
│   ├── entities/        # Business entities
│   ├── failures/        # Domain-specific failures
│   ├── inputs/          # Value objects and input validation
│   ├── repositories/    # Repository interfaces
│   └── usecases/        # Business use cases
├── infrastructure/      # Infrastructure layer (required for data access)
│   ├── mappers/         # Data transformation between layers
│   ├── models/          # Data models and DTOs
│   ├── repositories/    # Repository implementations
│   └── services/        # External service integrations
└── presentation/        # Presentation layer (required)
    ├── cubit/           # Feature-specific state management (alternative)
    ├── pages/           # Full-screen pages
    └── widgets/         # Reusable widgets
```

### Test Organization

Tests mirror the `lib/` structure:

- **Unit Tests**: Test individual classes and functions
- **Widget Tests**: Test individual widgets and their interactions
- **Integration Tests**: Test feature workflows and external integrations
- **Golden Tests**: Visual regression testing for UI components

## Special Directories

### Core Module

The `core/` directory contains shared infrastructure:

- **Bootstrap**: Application initialization and dependency setup
- **DI**: Dependency injection configuration using GetIt
- **Network**: HTTP client and API communication setup
- **Security**: Authentication, authorization, and security utilities
- **Storage**: Data persistence and caching abstractions
- **Themes**: Design system and theming
- **Utils**: Shared utility functions and helpers

### L10n Module

Internationalization support:

- **Generated Files**: Auto-generated translation classes
- **Source Files**: JSON translation files for each locale
- **Configuration**: Localization setup and configuration

### Documentation Structure

- **Architecture**: Technical documentation and system design
- **QA**: Quality assurance processes and testing documentation
- **Stories**: User stories and business requirements
- **BMAD**: AI-driven development methodology configuration

## Development Guidelines

### Adding New Features

1. Create feature directory under `features/`
2. Implement layers based on complexity (always include presentation)
3. Add corresponding test structure under `test/features/`
4. Update dependency injection configuration if needed
5. Add navigation routes if the feature has pages

### Core Module Changes

1. Consider impact on all features
2. Update documentation
3. Ensure backward compatibility
4. Run full test suite
5. Update dependency injection if adding new services

### Environment Configuration

1. Add new variables to all environment files
2. Update environment classes
3. Run code generation
4. Test in all environments
5. Update documentation

This source tree architecture supports the brownfield development approach while maintaining clean separation of concerns and enabling efficient AI-driven development through the BMAD methodology.
