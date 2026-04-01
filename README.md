# ThermaCore

ThermaCore is an F-Droid-compliant Android application built with Flutter that provides deep system-level thermal monitoring by reading hardware sensors directly from sysfs (`/sys/class/thermal/`).

## Features
* **Zero Network Permissions**: Strict F-Droid compliance (no trackers, no analytics)
* **Direct Hardware Access**: Uses a native Kotlin background service to read sysfs hardware sensors.
* **Continuous Monitoring**: Low-overhead foreground service that continuously polls temperature sensors.
* **Cooling Score**: A composite 0-100 score indicating overall system health.
* **Real-time Charting**: Interactive history chart showing temperature changes over time.
* **Alert System**: Local notifications on elevated temperatures.
* **AMOLED True-Black UI**: Battery-friendly futuristic dashboard.
* **CSV/JSON Exporter**: Save and share history sessions.

## Tech Stack
* **Framework**: Flutter 3.22.2
* **Language**: Dart, Kotlin
* **Architecture**: Riverpod (Providers) + Drift (SQLite)
* **Native Integration**: `MethodChannel`, Foreground Services, AppWidgets

## Build Instructions (Android)
Requires Android 8.0 (API 26) or higher.

```bash
cd thermacore
flutter pub get
dart run build_runner build -d
flutter build apk
```

## Privacy Policy
ThermaCore **never** connects to the internet. We do not collect, transmit, or share any of your device telemetry.