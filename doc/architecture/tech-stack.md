# XP1 Tech Stack

This document outlines the definitive technology stack for the XP1 Flutter Authentication project, serving as the single source of truth for all development decisions. All AI agents and developers must reference these choices.

**Relationship to Frontend Architecture:**
This document covers the complete technology stack for the mobile Flutter application. Core technology choices documented herein are definitive for the entire project.

## Starter Template or Existing Project

**Decision:** Very Good CLI Flutter Template

The project is based on the Very Good CLI Flutter template, which provides:

- Pre-configured technology stack and versions
- Comprehensive project structure following Flutter best practices
- Built-in scripts and tooling for development workflow
- Established architectural patterns (BLoC, Clean Architecture)
- Professional linting rules and code quality standards
- Comprehensive testing setup with coverage reporting

This foundation significantly accelerates development while ensuring adherence to industry best practices.

## Change Log

| Date         | Version | Description                   | Author      |
| ------------ | ------- | ----------------------------- | ----------- |
| January 2025 | 1.0     | Initial tech stack definition | BMad Master |

## High Level Architecture

### Technical Summary

The XP1 system implements a modern Flutter mobile application architecture utilizing the BLoC pattern for state management, with clean separation of concerns and comprehensive code generation. The architecture emphasizes type safety, testability, and maintainability through sophisticated tooling and established design patterns. Primary technology choices center around Flutter 3.24+ with Dart 3.8+, leveraging code generation for reduced boilerplate and compile-time safety. The system integrates with the PX1 API for authentication services while maintaining offline-capable state management through persistent BLoC implementation.

### High Level Overview

1. **Architecture Style:** Layered Clean Architecture with BLoC pattern
2. **Repository Structure:** Single Flutter project (not applicable for mobile app)
3. **Service Architecture:** Monolithic mobile application with external API integration
4. **User Interaction Flow:** Flutter UI → BLoC State Management → Chopper HTTP Client → PX1 API
5. **Key Decisions:**
   - BLoC for predictable state management and excellent testability
   - Code generation strategy for type safety and reduced runtime errors
   - Secure token storage using hardware-backed encryption
   - Comprehensive testing strategy with high coverage requirements

### Architectural and Design Patterns

- **BLoC Pattern:** Reactive state management with clear separation of business logic - _Rationale:_ Predictable state transitions, excellent testing capabilities, team expertise
- **Repository Pattern:** Abstract data access through generated HTTP clients - _Rationale:_ Enables testing, clear separation of concerns, type safety
- **Dependency Injection:** Service locator pattern with code generation - _Rationale:_ Testable architecture, clear dependency graphs, compile-time validation
- **Code Generation Strategy:** Heavy use of build*runner for reducing boilerplate - \_Rationale:* Type safety, reduced human error, improved developer experience
- **Secure Storage Pattern:** Hardware-backed encryption for sensitive data - _Rationale:_ Security compliance, cross-platform consistency

## Tech Stack

This is the **DEFINITIVE technology selection** for the XP1 Flutter Authentication project. All development must reference these choices as the single source of truth.

### Cloud Infrastructure

- **Provider:** Not applicable (Mobile app with API integration)
- **Key Services:** PX1 API (https://api-dev.px1.vn/api/v2.5/)
- **Deployment Regions:** Mobile app stores (iOS App Store, Google Play Store)

### Technology Stack Table

| Category                   | Technology                  | Version           | Purpose                         | Rationale                                                 |
| -------------------------- | --------------------------- | ----------------- | ------------------------------- | --------------------------------------------------------- |
| **Platform**               | Flutter                     | >=3.24.0          | Cross-platform mobile framework | Single codebase, excellent performance, mature ecosystem  |
| **Language**               | Dart                        | >=3.8.0           | Primary development language    | Strong typing, null safety, excellent Flutter integration |
| **Starter Template**       | Very Good CLI               | Latest            | Project scaffolding             | Industry best practices, comprehensive tooling setup      |
| **State Management**       | BLoC (flutter_bloc)         | 9.1.1             | Business logic separation       | Predictable state, excellent testing, team expertise      |
| **State Persistence**      | Hydrated BLoC               | 10.1.1            | Persistent state management     | Automatic state restoration, seamless user experience     |
| **HTTP Client**            | Chopper                     | 8.0.3             | Type-safe HTTP client           | Code generation, interceptors, excellent DX               |
| **HTTP Logging**           | Pretty Chopper Logger       | 1.3.0             | Request/response logging        | Development debugging, API integration testing            |
| **Security**               | Flutter Secure Storage      | 9.2.2             | Encrypted JWT token storage     | Hardware-backed security, cross-platform consistency      |
| **Form Validation**        | Formz                       | 0.7.0             | Type-safe form validation       | Immutable, testable, BLoC integration                     |
| **Dependency Injection**   | Get It + Injectable         | 8.0.2 + 2.5.1     | Service locator pattern         | Code generation, clear dependencies                       |
| **Navigation**             | Auto Route                  | 10.1.2            | Declarative routing             | Type-safe navigation, code generation                     |
| **Functional Programming** | Fpdart                      | 1.1.0             | Functional utilities            | Either types, immutability, error handling                |
| **Code Generation**        | Build Runner                | 2.7.1             | Dart code generation            | JSON, routing, DI code generation                         |
| **Internationalization**   | Slang + Slang Flutter       | 4.8.1 + 4.8.0     | Type-safe i18n                  | Code generation, excellent Flutter integration            |
| **UI Framework**           | Material Design             | Built-in          | Design system                   | Consistent UI, accessibility, platform guidelines         |
| **Typography**             | Google Fonts                | 6.2.1             | Font management                 | Professional typography, offline bundling                 |
| **Icons & Graphics**       | Flutter SVG                 | 2.0.10+1          | Vector graphics                 | Scalable icons, performance optimization                  |
| **Responsive Design**      | Flutter ScreenUtil          | 5.9.3             | Screen adaptation               | Consistent sizing across devices                          |
| **UI Components**          | Smooth Page Indicator       | 1.2.1             | Page indicators                 | Professional animations, smooth UX                        |
| **Utilities**              | Nil                         | 1.1.1             | Conditional rendering           | Lightweight null widget, better performance               |
| **Keyboard Handling**      | Flutter Keyboard Visibility | 6.0.0             | Keyboard detection              | Better UX, responsive layouts                             |
| **Testing Framework**      | Flutter Test + BLoC Test    | Built-in + 10.0.0 | Unit and widget testing         | Comprehensive testing capabilities                        |
| **Mocking**                | Mocktail                    | 1.0.4             | Test mocking                    | Modern mocking framework, null safety                     |
| **Widget Documentation**   | Widgetbook                  | 3.16.0            | Component library               | Visual component testing, design system docs              |
| **Linting**                | Very Good Analysis          | 9.0.0             | Code quality enforcement        | Industry-standard rules, comprehensive coverage           |
| **Environment Config**     | Envied                      | 1.2.0             | Secure environment variables    | Compile-time safety, no runtime exposure                  |
| **Logging**                | Logger                      | 2.6.1             | Application logging             | Structured logging, multiple outputs                      |
| **Local Storage**          | Shared Preferences          | 2.3.3             | Simple key-value storage        | Locale persistence, user preferences                      |
| **Development Tools**      | Dependency Validator        | 5.0.2             | Dependency management           | Unused dependency detection, optimization                 |
| **Git Workflow**           | Conventional Commit         | 0.6.1+1           | Commit message linting          | Standardized commit messages, changelog generation        |
| **Native Splash**          | Flutter Native Splash       | 2.4.6             | Splash screen generation        | Professional app launch experience                        |

## Data Models

### Authentication Models

**Purpose:** Core authentication entities for secure user session management

**Key Attributes:**

- user: User - User profile information
- accessToken: String - JWT access token for API authentication
- refreshToken: String - JWT refresh token for session renewal
- tokenType: String - Bearer token type
- ttl: int - Token time-to-live in seconds

**Relationships:**

- User has one AuthToken
- AuthToken belongs to one User
- AuthToken has expiration policies

### User Model

**Purpose:** User profile and account information

**Key Attributes:**

- id: String - Unique user identifier
- username: String - User login credential
- email: String? - Optional email address
- profile: UserProfile? - Optional extended profile information

**Relationships:**

- User has one AuthToken (when authenticated)
- User has optional UserProfile

## Components

### Authentication Component

**Responsibility:** Complete authentication flow management including login, logout, and session persistence

**Key Interfaces:**

- AuthBloc: Business logic for authentication state management
- AuthRepository: Data layer abstraction for authentication operations
- SecureStorageService: Secure token persistence service

**Dependencies:** Chopper HTTP client, Flutter Secure Storage, BLoC state management

**Technology Stack:** BLoC pattern with Chopper HTTP client and hardware-backed secure storage

### Form Validation Component

**Responsibility:** Type-safe form validation with real-time feedback and BLoC integration

**Key Interfaces:**

- LoginFormBloc: Form state management with validation
- FormzInput: Type-safe input validation classes
- ValidationHelpers: Reusable validation logic

**Dependencies:** Formz validation framework, BLoC pattern

**Technology Stack:** Formz with BLoC integration for immutable form state

### HTTP Client Component

**Responsibility:** Type-safe API communication with automatic code generation and logging

**Key Interfaces:**

- AuthApiService: Generated API client for authentication endpoints
- ApiInterceptors: Request/response interception for logging and auth
- ResponseHandlers: Centralized API response processing

**Dependencies:** Chopper HTTP client, Pretty Chopper Logger, JSON serialization

**Technology Stack:** Chopper with code generation, interceptors, and comprehensive logging

### Navigation Component

**Responsibility:** Type-safe routing with authentication guards and deep linking support

**Key Interfaces:**

- AppRouter: Generated routing configuration
- AuthGuard: Authentication-based route protection
- RouteHandlers: Deep link and navigation logic

**Dependencies:** Auto Route, authentication state

**Technology Stack:** Auto Route with code generation and guard integration

## External APIs

### PX1 Authentication API

- **Purpose:** User authentication and session management
- **Documentation:** Internal PX1 API documentation
- **Base URL(s):** https://api-dev.px1.vn/api/v2.5/
- **Authentication:** JWT Bearer token (for authenticated endpoints)
- **Rate Limits:** Standard API rate limiting (specific limits TBD)

**Key Endpoints Used:**

- `POST /login` - User authentication with credentials
- `POST /refresh` - Token refresh (if implemented)
- `POST /logout` - Session invalidation (if implemented)

**Integration Notes:** Uses Chopper HTTP client with Pretty Chopper Logger for development debugging. Implements secure token storage using Flutter Secure Storage.

## Database Schema

**Local Storage Schema (Flutter Secure Storage):**

```
Secure Storage Keys:
- "access_token": String (JWT access token)
- "refresh_token": String (JWT refresh token)
- "token_expiry": String (ISO 8601 timestamp)
- "user_profile": String (JSON serialized user data)

Shared Preferences Keys:
- "app_locale": String (selected application locale)
- "theme_mode": String (light/dark/system theme preference)
- "onboarding_completed": bool (first-time user flag)
```

**Schema Design Rationale:**

- Sensitive authentication data stored in hardware-backed secure storage
- User preferences stored in standard shared preferences
- JSON serialization for complex objects with type safety
- Clear separation between secure and non-secure data

## Source Tree

```
xp1/
├── lib/
│   ├── app/                          # Application configuration
│   │   ├── app.dart                  # Main app widget
│   │   └── app_bloc_observer.dart    # BLoC debugging
│   ├── bootstrap.dart                # App initialization
│   ├── core/                         # Core utilities and services
│   │   ├── di/                       # Dependency injection
│   │   ├── errors/                   # Error handling
│   │   ├── network/                  # HTTP client configuration
│   │   ├── router/                   # Navigation configuration
│   │   ├── storage/                  # Storage services
│   │   └── utils/                    # Utility functions
│   ├── features/                     # Feature modules
│   │   ├── auth/                     # Authentication feature
│   │   │   ├── data/                 # Data layer (repositories, models)
│   │   │   ├── domain/               # Domain layer (entities, use cases)
│   │   │   └── presentation/         # Presentation layer (BLoC, widgets)
│   │   ├── splash/                   # Splash screen feature
│   │   └── shared/                   # Shared components
│   ├── l10n/                         # Localization files
│   └── main_*.dart                   # Environment-specific entry points
├── test/                             # Test files (mirrors lib structure)
├── integration_test/                 # Integration tests
├── widgetbook/                       # Component documentation
├── assets/                           # Static assets
│   ├── fonts/
│   ├── icons/
│   └── images/
├── android/                          # Android platform code
├── ios/                              # iOS platform code
├── web/                              # Web platform code (if needed)
├── windows/                          # Windows platform code (if needed)
├── macos/                            # macOS platform code (if needed)
├── linux/                            # Linux platform code (if needed)
└── tool/                             # Build and utility scripts
```

## Infrastructure and Deployment

### Infrastructure as Code

- **Tool:** Not applicable (Mobile application)
- **Location:** Native platform configurations in platform directories
- **Approach:** Platform-specific build configurations and signing

### Deployment Strategy

- **Strategy:** App Store deployment through CI/CD pipelines
- **CI/CD Platform:** GitHub Actions (assumed based on project structure)
- **Pipeline Configuration:** `.github/workflows/` directory

### Environments

- **Development:** Local development with debug builds
- **Staging:** TestFlight (iOS) and internal testing (Android)
- **Production:** App Store (iOS) and Google Play Store (Android)

### Environment Promotion Flow

```
Development → Staging → Production
    ↓           ↓          ↓
Local Dev   TestFlight  App Store
           Internal     Play Store
```

### Rollback Strategy

- **Primary Method:** App Store rollback to previous version
- **Trigger Conditions:** Critical bugs, security vulnerabilities, excessive crash rates
- **Recovery Time Objective:** 24-48 hours (app store review dependent)

## Error Handling Strategy

### General Approach

- **Error Model:** Functional error handling using Either types from Fpdart
- **Exception Hierarchy:** Custom exceptions extending base Exception classes
- **Error Propagation:** BLoC events carry error states, UI displays user-friendly messages

### Logging Standards

- **Library:** Logger 2.6.1
- **Format:** Structured JSON logging with consistent fields
- **Levels:** trace, debug, info, warning, error, fatal
- **Required Context:**
  - Correlation ID: UUID v4 for request tracking
  - Service Context: Feature module and component identification
  - User Context: Anonymous user ID (no PII), session information

### Error Handling Patterns

#### External API Errors

- **Retry Policy:** Exponential backoff with maximum 3 retries
- **Circuit Breaker:** Not applicable (mobile client)
- **Timeout Configuration:** 30 seconds for authentication, 15 seconds for other requests
- **Error Translation:** API error codes mapped to user-friendly messages

#### Business Logic Errors

- **Custom Exceptions:** AuthenticationException, ValidationException, NetworkException
- **User-Facing Errors:** Localized error messages through Slang i18n
- **Error Codes:** Structured error codes for logging and analytics

#### Data Consistency

- **Transaction Strategy:** Atomic operations for critical state changes
- **Compensation Logic:** Rollback patterns for failed multi-step operations
- **Idempotency:** Idempotent operations for network request retries

## Coding Standards

### Core Standards

- **Languages & Runtimes:** Dart 3.8.0+, Flutter 3.24.0+
- **Style & Linting:** Very Good Analysis with zero tolerance for linter errors
- **Test Organization:** Test files mirror lib structure, 100% coverage requirement

### Naming Conventions

| Element   | Convention           | Example                |
| --------- | -------------------- | ---------------------- |
| Classes   | PascalCase           | `AuthenticationBloc`   |
| Methods   | camelCase            | `authenticateUser()`   |
| Variables | camelCase            | `accessToken`          |
| Constants | SCREAMING_SNAKE_CASE | `API_BASE_URL`         |
| Files     | snake_case           | `auth_repository.dart` |

### Critical Rules

- **Logging Rule:** Never use print() in production code - always use Logger instance
- **State Management Rule:** All state changes must go through BLoC pattern, no direct widget state
- **API Integration Rule:** All HTTP requests must use Chopper generated clients, no manual HTTP calls
- **Security Rule:** Never store sensitive data in SharedPreferences, only use FlutterSecureStorage
- **Error Handling Rule:** All async operations must use Either types for error handling
- **Testing Rule:** All public methods must have corresponding unit tests with 100% coverage
- **Code Generation Rule:** Always run build_runner after model changes before committing
- **Validation Rule:** All user inputs must use Formz validation, no manual validation logic

## Test Strategy and Standards

### Testing Philosophy

- **Approach:** Test-Driven Development (TDD) with Red-Green-Refactor cycle
- **Coverage Goals:** 100% line coverage, 95% branch coverage
- **Test Pyramid:** 70% unit tests, 20% widget tests, 10% integration tests

### Test Types and Organization

#### Unit Tests

- **Framework:** Flutter Test (built-in)
- **File Convention:** `*_test.dart` files mirror source structure
- **Location:** `test/` directory matching `lib/` structure
- **Mocking Library:** Mocktail 1.0.4
- **Coverage Requirement:** 100% line coverage

**AI Agent Requirements:**

- Generate tests for all public methods
- Cover edge cases and error conditions
- Follow AAA pattern (Arrange, Act, Assert)
- Mock all external dependencies

#### Integration Tests

- **Scope:** End-to-end user flows and critical business logic
- **Location:** `integration_test/` directory
- **Test Infrastructure:**
  - **API Mocking:** Mock server for API responses
  - **Storage:** In-memory storage for isolated testing

#### Widget Tests

- **Framework:** Flutter Test with widget testing utilities
- **Scope:** UI component behavior and interaction
- **Environment:** Isolated widget rendering and interaction testing
- **Test Data:** Predefined test fixtures and mock data

### Test Data Management

- **Strategy:** Factory pattern with randomized test data generation
- **Fixtures:** JSON fixtures stored in `test/fixtures/` directory
- **Factories:** Test object factories for consistent test data
- **Cleanup:** Automatic cleanup between test runs

### Continuous Testing

- **CI Integration:** Tests run on every pull request and commit to main
- **Performance Tests:** Widget rendering performance benchmarks
- **Security Tests:** Static analysis and dependency vulnerability scanning

## Security

### Input Validation

- **Validation Library:** Formz 0.7.0 with custom validation rules
- **Validation Location:** At BLoC layer before business logic processing
- **Required Rules:**
  - All external inputs MUST be validated
  - Validation at presentation layer before state management
  - Whitelist approach preferred over blacklist

### Authentication & Authorization

- **Auth Method:** JWT Bearer token authentication with PX1 API
- **Session Management:** Secure token storage with automatic expiration handling
- **Required Patterns:**
  - Automatic token refresh before expiration
  - Secure logout with complete token cleanup

### Secrets Management

- **Development:** Environment variables through Envied with compile-time safety
- **Production:** Flutter Secure Storage for runtime secrets (tokens)
- **Code Requirements:**
  - NEVER hardcode secrets in source code
  - Access via secure storage service only
  - No secrets in logs or error messages

### API Security

- **Rate Limiting:** Handled by PX1 API server-side
- **CORS Policy:** Not applicable (mobile client)
- **Security Headers:** HTTP security headers handled by Chopper interceptors
- **HTTPS Enforcement:** Certificate pinning for API communications

### Data Protection

- **Encryption at Rest:** Flutter Secure Storage with hardware-backed encryption
- **Encryption in Transit:** HTTPS/TLS for all API communications
- **PII Handling:** No PII stored locally, minimal PII in logs
- **Logging Restrictions:** No passwords, tokens, or sensitive user data in logs

### Dependency Security

- **Scanning Tool:** Dependency validator and GitHub security advisories
- **Update Policy:** Monthly dependency updates with security patch priority
- **Approval Process:** Security review required for new dependencies

### Security Testing

- **SAST Tool:** Built into Very Good Analysis linting rules
- **DAST Tool:** Manual penetration testing during release cycles
- **Penetration Testing:** Quarterly security assessment

---

**Document Control**

- Created: January 2025
- Last Modified: January 2025
- Next Review: February 2025
- Owner: Development Team
- Version: 1.0
