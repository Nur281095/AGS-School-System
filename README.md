# AGS School System

AGS School System is a Flutter desktop application targeting Windows that helps administrators manage school operations offline. The project embraces Material 3 design language with a focus on clean, professional UI, gradient-driven layout chrome, and modular architecture powered by Riverpod, go_router, and Drift for local persistence.

## Getting Started

> **Prerequisites**
>
> - Flutter 3.16 or newer with Windows desktop support enabled.
> - Dart 3.2 or newer.

1. Fetch dependencies and generate Drift sources:
   ```bash
   flutter pub get
   dart run build_runner build --delete-conflicting-outputs
   ```
2. Run the desktop app:
   ```bash
   flutter run -d windows
   ```

## Architecture

```
lib/
  app/        # Routing, theming, application-wide providers
  core/       # Reusable models and utilities
  data/       # Drift database, repositories, and DAOs
  features/   # Feature-driven modules (teachers, students, etc.)
  widgets/    # Design system building blocks (to be expanded)
```

- **State management**: [Riverpod](https://riverpod.dev)
- **Routing**: [go_router](https://pub.dev/packages/go_router)
- **Database**: [Drift](https://drift.simonbinder.eu/) with `sqlite3_flutter_libs`
- **UI components**: Material 3 widgets, a bespoke navigation shell, and [DataTable2](https://pub.dev/packages/data_table_2) for advanced tabular layouts

## Teachers Module (Step 1)

The first module focuses on teacher management with full CRUD capabilities and rich filters.

### Screens

- **Teachers Workspace**: Rich DataTable2 view with summary analytics, inline status filtering, contextual actions, and offline-friendly navigation shell.
- **Add/Edit Teacher Dialog**: Guided form capturing contact information, optional CNIC/ID, hire date, and availability status with segmented controls.

### Database Schema

- `teachers`: stores core teacher profile fields.
- `teacher_subjects`: planned for later many-to-many relationship with subjects (not yet implemented).

### Highlights

- Responsive navigation shell with gradient chrome, offline badge, and expandable workspace container.
- Real-time metrics for total, active, inactive, and archived teachers rendered as dashboard cards.
- Search-as-you-type filters with status chips, reusable sort menu, and reset affordances.
- Elegant status badges, contextual action menus, and segmented status selector in the form dialog.
- Seed data to experience the UI immediately after the first launch.

## Next Steps

- Extend Drift schema for subjects and class assignments.
- Add reporting dashboards with `fl_chart`.
- Integrate PDF/printing workflows for challans and payslips.

