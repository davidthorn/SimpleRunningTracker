# AGENTS.md

This file defines repository-specific rules for coding agents (including Codex) working on `SimpleRunningTracker`.

## Mission

Keep this project a clean, scalable SwiftUI scaffold that junior and intermediate developers can adopt and extend.

Prioritize:

- clear architecture boundaries
- safe concurrency
- permission-first location handling
- testable dependencies
- maintainable feature growth

## Non-Negotiable Rules

1. Keep Swift version compatibility at **Swift 6**.
2. Do not add business logic directly in Views.
3. Keep navigation ownership in `Scene` types.
4. Keep persistence/state mutation in the store/service layer.
5. Use protocol-driven dependency injection at boundaries.
6. Keep store/service streaming based on `AsyncStream` where async updates are exposed.
7. Do not start location tracking/map-driven run flows before authorization is granted.

## Project Architecture

### Folder responsibilities

- `Scenes/`: top-level navigation owners (`NavigationStack` + destinations)
- `Views/`: screen UI only
- `Components/`: reusable UI units shared by views
- `ViewModels/`: presentation/business logic, async workflows, derived UI state
- `Services/`: concrete service implementations (location + actor-backed store) + service container
- `Protocols/`: dependency contracts (`*Protocol`)
- `Routes/`: route enums used by scene-owned navigation
- `Models/`: domain models

### Navigation rules

- `Scene` owns `.navigationDestination(for:)` for its flow.
- Child views/components emit route values, but do not own destination mapping.
- Do not scatter navigation destination wiring across feature views.

## View / ViewModel Rules

1. Views render state and forward user actions.
2. ViewModels perform async work and hold mutable presentation state.
3. If logic grows beyond simple UI glue, move it from View to ViewModel.
4. Keep view models `@MainActor` when publishing UI-facing state.
5. View starts async work using `Task` and calls async ViewModel methods.

## Store + Location + Concurrency Rules

1. Persisted run data is owned by actor-backed store implementation.
2. Expose async change streams with `AsyncStream`.
3. Keep file persistence concerns in store layer only.
4. Respect actor isolation and avoid redundant synchronization primitives.
5. Location authorization must be checked before tracking starts.
6. Map and run capture UI should not attempt location-driven updates when permission is unavailable.

## Dependency Injection Rules

1. Depend on protocols (`*Protocol`) at boundaries.
2. Compose concrete implementations in app root/container.
3. Prefer initializer injection.
4. Avoid direct concrete construction deep inside Views/ViewModels.
