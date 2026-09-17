AI Development Instructions — Flutter App

1. Purpose

This document defines the architecture, project structure, coding conventions, and fundamental development rules for this Flutter application.

The AI must follow these instructions whenever it creates, modifies, or refactors code.

The main goals are:

Keep the codebase clean and predictable.

Separate presentation, business logic, and data access.

Make features easy to find and maintain.

Prefer reusable components over duplicated UI/code.

Keep dependencies flowing in one direction.

Keep the application consistent in appearance and behavior.

Avoid unnecessary complexity.

2. Architecture

The application should follow a Clean Architecture-inspired structure, organized primarily by feature inside the presentation layer and by responsibility inside the domain/data layers.

The dependency direction should be:

Presentation
    ↓
Domain
    ↑
Data

More precisely:

Presentation → Domain
Data → Domain

The Domain layer must not depend on Flutter, UI code, DTOs, API clients, or database-specific implementations.

The Presentation layer must not directly access API clients, DTOs, or repository implementations.

The Data layer implements the repository interfaces defined by the Domain layer.

3. Recommended Project Structure

Use the following structure as the default:

lib/
│
├── app/
│   ├── app.dart
│   ├── router/
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   └── app_spacing.dart
│   │
│   └── di/
│       ├── injection.dart
│       └── injection.config.dart
│
├── core/
│   ├── error/
│   ├── network/
│   ├── constants/
│   ├── extensions/
│   ├── utils/
│   └── widgets/
│
├── presentation/
│   ├── widgets/
│   │   └── reusable widgets
│   │
│   └── screens/
│       │
│       └── home_screen/
│           ├── home_screen.dart
│           │
│           └── bloc/
│               ├── home_screen_bloc.dart
│               ├── home_screen_event.dart
│               └── home_screen_state.dart
│
├── domain/
│   ├── models/
│   │   └── domain models
│   │
│   └── home_screen/
│       ├── home_screen_usecase.dart
│       └── home_screen_repository.dart
│
├── data/
│   ├── dto/
│   │   └── DTO models
│   │
│   └── repositories/
│       └── home_screen_repository_impl.dart
│
└── l10n/
    ├── app_en.arb
    └── app_sr.arb

The exact structure may evolve as the application grows, but new code should follow the same architectural principles.

4. Presentation Layer

The presentation layer contains everything related to displaying and interacting with the UI.

It should contain:

Screens

BLoCs

Events

States

Reusable presentation widgets

The presentation layer should not contain business logic that belongs in the domain layer.

4.1 Screens

Each screen should have its own folder.

Example:

presentation/
└── screens/
    └── home_screen/
        ├── home_screen.dart
        └── bloc/
            ├── home_screen_bloc.dart
            ├── home_screen_event.dart
            └── home_screen_state.dart

The main screen file should be:

home_screen.dart

The screen-specific BLoC should be inside:

bloc/

5. BLoC Rules

Use BLoC for screen/application state management.

A screen BLoC should generally contain:

home_screen_bloc.dart
home_screen_event.dart
home_screen_state.dart

The BLoC is responsible for:

Receiving UI events.

Calling use cases.

Transforming domain results into presentation state.

Managing loading/success/error states.

Coordinating screen state.

The BLoC should not:

Call an API directly.

Know about DTOs.

Know about repository implementations.

Contain large amounts of UI code.

Contain business logic that belongs in a use case.

Preferred flow:

Widget
   ↓
BLoC Event
   ↓
BLoC
   ↓
Use Case
   ↓
Repository Interface
   ↓
Repository Implementation
   ↓
API / Database

And the result flows back:

API / Database
   ↓
Repository Implementation
   ↓
Domain Model
   ↓
Use Case
   ↓
BLoC
   ↓
State
   ↓
Widget

6. Domain Layer

The domain layer contains the application's core business concepts.

It should be independent from Flutter and external technologies.

The domain layer contains:

Domain models

Use cases

Repository interfaces

Example:

domain/
├── models/
│   └── customer.dart
│
└── home_screen/
    ├── home_screen_usecase.dart
    └── home_screen_repository.dart

7. Domain Models

Domain models represent data used by the business/application logic.

They should not be tied to:

JSON

API responses

Retrofit

Dio

database schemas

Flutter widgets

For example:

class Customer {
  final String id;
  final String name;

  const Customer({
    required this.id,
    required this.name,
  });
}

If the API returns a different structure, the Data layer should map the DTO to the domain model.

8. Use Cases

Use cases represent actions the application can perform.

Examples:

GetHomeScreenDataUseCase
GetCustomersUseCase
CreatePaymentRequestUseCase
SendPaymentReminderUseCase

A use case should generally represent one meaningful business action.

Avoid creating use cases for trivial operations that add no architectural value.

Example:

class GetHomeScreenDataUseCase {
  final HomeScreenRepository repository;

  GetHomeScreenDataUseCase(this.repository);

  Future<HomeScreenData> call() {
    return repository.getHomeScreenData();
  }
}

The use case depends on the repository interface, never the implementation.

9. Repository Interfaces

Repository interfaces belong to the Domain layer.

Example:

abstract class HomeScreenRepository {
  Future<HomeScreenData> getHomeScreenData();
}

The interface defines what the application needs.

It should not care how the data is obtained.

For example, the domain should not know whether the data comes from:

REST API

Supabase

Firebase

SQLite

local storage

another service

That decision belongs to the Data layer.

10. Data Layer

The Data layer handles external data sources.

It contains:

DTOs

Repository implementations

API/database communication

Mapping between external data and domain models

Example:

data/
├── dto/
│   └── home_screen_dto.dart
│
└── repositories/
    └── home_screen_repository_impl.dart

11. DTOs

DTOs represent external data structures.

For example, an API response:

{
  "id": "123",
  "customer_name": "John"
}

may have:

class CustomerDto {
  final String id;
  final String customerName;
}

DTOs may use:

json_serializable

Retrofit

Dio

API-specific annotations

DTOs should not leak into the Presentation layer.

Convert DTOs into domain models inside the Data layer.

Example:

extension CustomerDtoMapper on CustomerDto {
  Customer toDomain() {
    return Customer(
      id: id,
      name: customerName,
    );
  }
}

12. Repository Implementations

Repository implementations belong to the Data layer.

Example:

class HomeScreenRepositoryImpl implements HomeScreenRepository {
  final HomeApi api;

  HomeScreenRepositoryImpl(this.api);

  @override
  Future<HomeScreenData> getHomeScreenData() async {
    final dto = await api.getHomeScreenData();

    return dto.toDomain();
  }
}

The implementation:

Talks to external services.

Receives DTOs.

Maps DTOs to domain models.

Implements the domain repository interface.

13. Dependency Injection

Use:

get_it

injectable

for dependency injection.

Dependencies should be registered through Injectable rather than manually constructing dependencies throughout the application.

Example:

@injectable
class GetHomeScreenDataUseCase {
  final HomeScreenRepository repository;

  GetHomeScreenDataUseCase(this.repository);
}

Repository implementation:

@LazySingleton(as: HomeScreenRepository)
class HomeScreenRepositoryImpl implements HomeScreenRepository {
  ...
}

Use appropriate Injectable annotations such as:

@injectable
@lazySingleton
@singleton
@factory

based on the lifecycle required.

Do not create dependencies directly inside widgets or BLoCs when dependency injection should be used.

Avoid:

final repository = HomeScreenRepositoryImpl(...);

inside presentation code.

Instead, retrieve dependencies through the DI system.

14. Reusable Widgets

Reusable widgets belong in:

presentation/widgets/

if they are presentation/UI components shared across screens.

Examples:

presentation/widgets/
├── app_button.dart
├── app_text_field.dart
├── app_loading_indicator.dart
├── app_error_view.dart
└── app_card.dart

A widget should become reusable when:

It appears on multiple screens.

It represents a common UI pattern.

Reusing it improves consistency.

It contains enough logic/structure that duplication would be undesirable.

Do not create a reusable widget simply to avoid having a few lines of UI in a screen.

Prefer clear and meaningful widget names.

15. Core Layer

Use core/ for functionality that is genuinely application-wide and not specific to one feature.

Examples:

core/
├── error/
├── network/
├── constants/
├── extensions/
├── utils/
└── widgets/

Use core/ carefully.

Do not put feature-specific code into core/ just because it is convenient.

A useful rule:

If the code only makes sense for one feature, keep it with that feature.

16. Theme

The application should have a centralized theme.

Do not define random colors, text styles, or spacing values throughout screens.

Use:

app/
└── theme/
    ├── app_theme.dart
    ├── app_colors.dart
    ├── app_text_styles.dart
    └── app_spacing.dart

Example:

class AppColors {
  static const primary = ...;
  static const background = ...;
  static const error = ...;
}

Example:

class AppTextStyles {
  static const title = ...;
  static const subtitle = ...;
  static const body = ...;
  static const caption = ...;
}

Example:

class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
}

The exact values can change, but the application should have a consistent design system.

Prefer using:

Theme.of(context).colorScheme

and:

Theme.of(context).textTheme

when appropriate.

Do not introduce a new color or text style for a single widget unless there is a real design requirement.

17. Localization

The application must support both Serbian and English.

Use Flutter localization with .arb files:

l10n/
├── app_en.arb
└── app_sr.arb

All user-visible strings should be localized.

Avoid:

Text('Save')

Prefer generated localization:

Text(context.l10n.save)

Do not hardcode user-facing strings inside widgets.

When adding a new user-facing string:

Add the English translation.

Add the Serbian translation.

Use the generated localization accessor.

Do not leave one language missing.

Technical/debug strings that are never displayed to users do not need localization.

18. Naming Conventions

Follow standard Dart/Flutter naming conventions.

Files

Use snake_case:

home_screen.dart
payment_request_bloc.dart
customer_repository.dart

Classes

Use PascalCase:

HomeScreen
PaymentRequestBloc
CustomerRepository

Variables and methods

Use camelCase:

customerName
loadCustomers()
createPaymentRequest()

Constants

Follow Dart conventions and use descriptive names.

Avoid meaningless names such as:

data1
temp
thing
test2

unless genuinely appropriate in a very local context.

19. Async and Error Handling

Do not silently ignore errors.

Handle failures explicitly.

Prefer a consistent application error strategy.

For example:

Loading
Success
Failure

or an equivalent state representation.

The UI should be able to distinguish between:

loading

successful data

empty data

failure

Avoid showing a blank screen when an operation fails.

Errors should be handled at the appropriate architectural boundary.

20. Null Safety

Use Dart null safety correctly.

Avoid unnecessary:

!

Do not use null assertions simply to silence the compiler.

Prefer:

if (value == null) {
  ...
}

or other appropriate null-safe patterns.

Only make a value nullable when null represents a meaningful state.

21. Avoid Overengineering

Clean Architecture does not mean every line needs its own abstraction.

Do not create:

unnecessary interfaces

unnecessary use cases

unnecessary wrapper classes

unnecessary helper classes

abstractions that have only one trivial use

The goal is maintainability, not maximum number of files.

Use architecture to make responsibilities clear.

22. Single Responsibility

Each class should have a clear responsibility.

For example:

Widget
→ UI

BLoC
→ Presentation state

Use Case
→ Business action

Repository Interface
→ Domain contract

Repository Implementation
→ Data access

DTO
→ External data representation

Avoid classes that do all of these at once.

23. Do Not Mix Layers

Avoid code such as:

class HomeScreenBloc {
  final Dio dio;
}

The BLoC should not directly use Dio.

Avoid:

class HomeScreen {
  final HomeScreenRepositoryImpl repository;
}

The presentation layer should depend on the domain abstraction/use case rather than the concrete data implementation.

Avoid returning DTOs from domain use cases.

Use:

DTO → Domain Model → Presentation

not:

DTO → Presentation

24. Feature Growth

When a feature becomes large, organize it without breaking the architectural boundaries.

For example:

presentation/
└── screens/
    └── payment_requests/
        ├── payment_requests_screen.dart
        ├── widgets/
        └── bloc/
            ├── payment_requests_bloc.dart
            ├── payment_requests_event.dart
            └── payment_requests_state.dart

The same feature can have corresponding domain/data code:

domain/
└── payment_requests/
    ├── payment_request_repository.dart
    ├── create_payment_request_usecase.dart
    └── get_payment_requests_usecase.dart

data/
├── dto/
│   └── payment_request_dto.dart
│
└── repositories/
    └── payment_request_repository_impl.dart

Keep the naming consistent across layers.

25. Code Generation

If the project uses generated code, do not manually edit generated files.

Examples:

*.g.dart
*.config.dart

These files should be generated by the appropriate tools.

After changing annotations or generated models, run the project's code generation command.

Typical command:

dart run build_runner build --delete-conflicting-outputs

Use the project's existing generation command if it differs.

26. Imports

Prefer package imports for application code:

import 'package:my_app/...';

Avoid complicated relative imports such as:

../../../../domain/...

unless there is a specific reason.

Keep imports clean and remove unused imports.

27. UI Guidelines

Prefer small, readable widgets.

If a build() method becomes difficult to understand, extract meaningful widgets.

Prefer:

const

constructors and widgets whenever possible.

Avoid unnecessary rebuilds.

Do not put heavy computation inside build().

The UI should primarily describe the UI, while state and business logic live elsewhere.

28. Constants

Do not scatter magic numbers throughout the application.

Instead of:

Padding(
  padding: EdgeInsets.all(17),
)

prefer a design-system value where appropriate:

Padding(
  padding: EdgeInsets.all(AppSpacing.md),
)

This is especially important for:

spacing

border radius

animation durations

common sizes

colors

typography

29. Comments

Prefer self-explanatory code over excessive comments.

Use comments when they explain:

Why something is done.

A non-obvious business rule.

A workaround.

An important architectural decision.

Do not add comments that simply restate the code.

Bad:

// Set loading to true
isLoading = true;

Better:

// Codeks occasionally returns an empty response while the sync is still processing.

30. AI Development Rules

When the AI is asked to modify the application:

Inspect the existing architecture before creating new files.

Reuse existing patterns whenever possible.

Do not introduce a new architecture for one feature.

Do not duplicate existing widgets, services, utilities, or models.

Search for an existing implementation before creating a new one.

Keep changes limited to what is required.

Do not modify unrelated code.

Preserve existing behavior unless the task explicitly requires changing it.

Follow existing naming conventions.

Use dependency injection for dependencies.

Keep UI code in Presentation.

Keep business logic in Domain.

Keep external data handling in Data.

Keep reusable application-wide functionality in Core.

Use localization for all user-facing strings.

Use the centralized theme instead of introducing arbitrary styling.

Prefer simple solutions over unnecessary abstractions.

Do not silently ignore errors.

Do not manually edit generated files.

Before finishing, check for compile errors, imports, type errors, and architectural violations.

31. When Creating a New Feature

When adding a new feature, follow this general process:

Step 1 — Understand the feature

Determine:

What does the user need to do?

What data is required?

Is there existing functionality that can be reused?

Step 2 — Create the presentation structure

Example:

presentation/screens/example_screen/
├── example_screen.dart
└── bloc/
    ├── example_screen_bloc.dart
    ├── example_screen_event.dart
    └── example_screen_state.dart

Step 3 — Define the domain

Create:

domain model(s), if needed

repository interface

use case(s)

Step 4 — Implement data access

Create:

DTO(s)

API/data source code if needed

repository implementation

DTO → domain mapping

Step 5 — Register dependencies

Add the appropriate Injectable annotations and regenerate DI code.

Step 6 — Connect the BLoC

The BLoC should call the use case.

Step 7 — Build the UI

The screen should react to BLoC states and dispatch BLoC events.

Step 8 — Localization

Add all user-facing strings to:

app_en.arb
app_sr.arb

Step 9 — Styling

Use the existing theme, text styles, colors, spacing, and reusable widgets.

Step 10 — Verify

Check:

analyzer

generated code

imports

localization generation

DI generation

runtime behavior

32. Fundamental Principle

When deciding where code belongs, ask:

"Which layer should know about this?"

Use this rule:

UI concern?
→ Presentation

Screen state?
→ BLoC

Business rule/action?
→ Domain / Use Case

Business model?
→ Domain Model

API/JSON/database concern?
→ Data / DTO

Repository contract?
→ Domain

Repository implementation?
→ Data

Shared UI?
→ Presentation widgets

Application-wide infrastructure?
→ Core

Dependency construction?
→ DI

The goal is not simply to have folders called Clean Architecture.

The goal is to maintain clear boundaries, predictable dependencies, reusable code, and a codebase that remains easy to understand as the application grows.