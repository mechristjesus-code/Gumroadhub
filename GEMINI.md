# Project Architecture & Conventions: Gumroad Creator Hub

This file defines the team-shared conventions for the Gumroad Creator Hub repository.

## 1. Architectural Pattern
- **State Management**: Provider (for manageable, granular UI updates).
- **Navigation**: `go_router` (declarative, scalable routing).
- **Data Layer**:
    - **Models**: Immutable classes utilizing `Equatable`.
    - **Services**: Network (`Dio`), Local Storage (`Hive`), Security (`flutter_secure_storage`).
    - **AI/Advanced**: Dedicated service classes (e.g., `WordGenie`, `LlamaManager`).

## 2. Coding Standards
- **Serialization**: Prefer manual `fromJson`/`toJson` for stability in this prototype, moving to `json_serializable` as models grow.
- **UI**: Material 3 components exclusively. Follow adaptive layout practices.
- **Documentation**: All new features must be added to `UPGRADES.md`.

## 3. Workflow
- Always implement logic in isolated service classes.
- Wrap all sensitive data storage (`tokens`, `API keys`) in `flutter_secure_storage`.
- Test all new models and UI components before committing.
