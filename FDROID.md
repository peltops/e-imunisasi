# F-Droid Publishing Guide for e-imunisasi

This document provides instructions for building and publishing e-imunisasi on F-Droid.

## About e-imunisasi

e-imunisasi is a mobile application designed for families and healthcare workers to simplify the immunization and vaccination process for infants and young children.

## Building for F-Droid

### Prerequisites

- Flutter SDK (version compatible with the app)
- Android SDK
- Java Development Kit (JDK) 11

### Build Steps

1. Clone the repository:
   ```
   git clone https://github.com/peltops/e-imunisasi.git
   cd e-imunisasi
   ```

2. Set the environment variable to indicate F-Droid build:
   ```
   export FDROID_BUILD=1
   ```

3. Get Flutter dependencies:
   ```
   flutter pub get
   ```

4. Build the APK:
   ```
   flutter build apk --release
   ```

5. The APK will be available at:
   ```
   build/app/outputs/flutter-apk/app-release.apk
   ```

## F-Droid Metadata

The F-Droid metadata is located in the following directories:

- `/metadata/com.peltops.e_imunisasi.yml` - Main F-Droid metadata file
- `/android/fastlane/metadata/android/` - App descriptions and changelogs

## License

This app is licensed under the GPL-3.0 license.

## Contact

For questions about the app or its F-Droid publication, please contact:
- Email: info@peltops.com
- Website: https://peltops.com