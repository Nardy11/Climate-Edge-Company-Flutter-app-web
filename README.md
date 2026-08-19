# Climate Edge

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)

A cross-platform Flutter application for Climate Edge, integrating Firebase for authentication and data, with document handling for company files.

## Features

- **Firebase Authentication** — user sign-in and account management
- **Cloud Firestore** — real-time application data
- **Firebase Storage** — company file/document storage
- **File picking** (`file_picker`) — upload documents from device
- **PDF viewing** (`flutter_pdfview`) — view documents in-app
- **File downloads** (`flutter_downloader`, `dio`) — download stored files to device

## Technology

- Flutter & Dart
- Firebase (Auth, Firestore, Storage)
- Cross-platform targets: Android, iOS, web, Windows, macOS, Linux

## Run locally

1. Install [Flutter](https://docs.flutter.dev/get-started/install).
2. Clone the repository:
   ```bash
   git clone https://github.com/Nardy11/Climate-Edge-Company-Flutter-app-web.git
   cd Climate-Edge-Company-Flutter-app-web
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Configure a Firebase project for your target platform(s) (`flutterfire configure`).
5. Run the application:
   ```bash
   flutter run
   ```

## Project structure

- `lib/` — application source (screens, services, Firebase integration)
- `assets/` — images used by the app
- `test/` — Flutter test directory

## License

MIT — see [LICENSE](./LICENSE).
