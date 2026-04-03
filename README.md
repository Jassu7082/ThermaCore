# <img src="thermacore/assets/image/thermacore_icon_192.png" width="48" height="48"> ThermaCore

ThermaCore is an F-Droid-compliant Android application built with Flutter that provides deep system-level thermal monitoring by reading hardware sensors directly from sysfs (`/sys/class/thermal/`).

## Features
* **Zero Network Permissions**: Strict F-Droid compliance (no trackers, no analytics).
* **EMA Smoothing**: Advanced Exponential Moving Average filter ensures stable, jitter-free temperature readings.
* **Persistent History (SQLite)**: Integrated Drift database for 24-hour historical data retrieval.
* **24-Hour Cooling Score**: Analyzes historical peak stress and average health to give a more realistic performance score.
* **Direct Hardware Access**: Uses a native Kotlin background service to read sysfs hardware sensors.
* **Interactive Zone Guide**: Educational guide in-app explaining hardware thermal identifiers.
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