# HumanIQ Mobile

This repository contains the Flutter mobile application for the HumanIQ project. It is designed to replicate the functionality of the HumanIQ web application in a mobile-friendly way.

## Features

- User Authentication (Login, Registration, and Logout)
- Role-based Dashboards:
  - Admin Dashboard
  - Manager Dashboard
  - Employee Dashboard
  - Super Admin Dashboard
- Data Visualization (Charts, Tables)
- Calendar Integration
- Multi-Device Compatibility (Android & iOS)

## Tech Stack

- **Flutter**: Cross-platform mobile development framework
- **Dart**: Programming language for Flutter
- **Provider**: State management
- **Dio**: API requests
- **Shared Preferences**: Local storage
- **fl_chart**: For charts and graphs
- **table_calendar**: For calendar views

## Getting Started

Follow these steps to set up the project on your local machine.

### Prerequisites

1. Install Flutter: Follow the instructions on [Flutter's official website](https://flutter.dev/docs/get-started/install).
2. Set up your development environment:
   - **Android**: Install Android Studio and set up an Android Virtual Device (AVD).
   - **iOS**: Install Xcode and set up an iOS simulator or connect a physical iPhone.
3. Verify your Flutter installation:
   ```bash
   flutter doctor
   ```

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/HumanIQ-Mobile.git
   cd HumanIQ-Mobile
   ```

2. Fetch all dependencies:
   ```bash
   flutter pub get
   ```

3. Run the project:
   ```bash
   flutter run
   ```

   - Use `flutter run` to launch the app on a connected device or emulator.
   - For Android, ensure USB debugging is enabled or an emulator is running.
   - For iOS, ensure Xcode is installed and a simulator or device is connected.

## Folder Structure

```
lib/
├── core/
│   ├── constants/         # App-wide constants (e.g., API endpoints, colors)
│   ├── services/          # Core services (e.g., API service, authentication)
│   ├── theme/             # Application theme and styles
│   └── utils/             # Utility functions and helpers
├── data/
│   ├── models/            # Data models (e.g., User, DashboardItem)
│   └── repositories/      # Data fetching and management
├── features/
│   ├── auth/              # Authentication module
│   ├── admin/             # Admin-specific screens and logic
│   ├── manager/           # Manager-specific screens and logic
│   ├── employee/          # Employee-specific screens and logic
│   └── super_admin/       # Super admin-specific screens and logic
├── shared/
│   ├── widgets/           # Reusable widgets (e.g., buttons, loaders)
│   └── providers/         # Global state management
└── main.dart              # Application entry point
```

## Dependencies

The project uses the following dependencies:

- `provider`: State management
- `dio`: HTTP client for API requests
- `shared_preferences`: Local storage for saving user data
- `fl_chart`: Data visualization (charts & graphs)
- `table_calendar`: Calendar widget for scheduling and events
- `google_fonts`: Custom fonts support
- `intl`: Internationalization and number/date formatting

To view all dependencies, refer to the [`pubspec.yaml`](pubspec.yaml) file.

## Contributing

Contributions are welcome! If you'd like to contribute, please follow these steps:

1. Fork the repository.
2. Create a new branch:
   ```bash
   git checkout -b feature/YourFeatureName
   ```
3. Make your changes and commit them:
   ```bash
   git commit -m "Add YourFeatureName"
   ```
4. Push to the branch:
   ```bash
   git push origin feature/YourFeatureName
   ```
5. Create a pull request.



## Contact

If you have any questions or need further assistance, feel free to contact