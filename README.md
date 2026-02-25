# Billzo

A modern, offline-first invoice generator app built with Flutter.

## Features

- **Dashboard** - Overview of total balance, monthly revenue, pending amounts, and recent invoices
- **Invoice Management** - Create, preview, and manage invoices with line items, taxes, and discounts
- **Client Management** - Add and manage clients with contact details and billing history
- **Profile & Settings** - Configure business details, currency, and app preferences
- **Offline-First** - All data stored locally using Hive, with Supabase sync provisions

## Tech Stack

- **Flutter** - Cross-platform UI framework
- **Cubit (flutter_bloc)** - State management
- **GoRouter** - Declarative navigation with persistent bottom navigation
- **Hive** - Local NoSQL database for offline-first storage
- **GetIt** - Dependency injection
- **Equatable** - Value equality for entities

## Architecture

Clean Architecture with three layers:

```
lib/src/
├── config/           # Theme, router configuration
├── core/             # DI, sync services, network utilities
├── features/         # Feature modules
│   ├── dashboard/    # Home dashboard
│   ├── invoice/      # Invoice CRUD & preview
│   ├── clients/      # Client management
│   └── profile/      # User settings
└── shared/           # Shared widgets
```

Each feature follows the pattern:
- `domain/` - Entities, repositories (abstract), use cases
- `data/` - Models, data sources, repository implementations
- `presentation/` - Cubits, states, pages, widgets

## Getting Started

### Prerequisites

- Flutter SDK (3.x+)
- Dart SDK (3.x+)

### Installation

```bash
# Clone the repository
git clone <repo-url>
cd billzo

# Install dependencies
flutter pub get

# Run the app
flutter run
```

## Default Currency

The app uses **Indian Rupee (₹)** as the default currency. This can be changed in Profile & Settings.

## Offline-First Architecture

- All invoices and clients are stored locally in Hive
- Sync infrastructure is in place for future Supabase integration
- `SyncStatus` tracks entity sync state (pendingCreate, pendingUpdate, pendingDelete, synced)
- `SyncManager` handles automatic sync on connectivity changes

## Screenshots

| Dashboard | Invoices | Create Invoice |
|-----------|----------|----------------|
| Home with balance card, quick actions, recent invoices | Invoice list with search and filters | Form with line items, taxes, notes |

| Invoice Preview | Clients | Profile |
|-----------------|---------|---------|
| Professional invoice layout | Client list with billing stats | Business settings and preferences |

## License

MIT License
