# Requirements

## System Requirements

### Operating Systems
- **Windows**: Windows 10 or later (64-bit)
- **macOS**: macOS 10.15 or later
- **Linux**: Ubuntu 18.04 or later (or equivalent)
- **iOS**: macOS with Xcode for development

## Flutter Requirements

- **Flutter SDK**: ^3.8.1 or higher
- **Dart SDK**: ^3.8.1 or higher (included with Flutter)

### Download Flutter
Visit: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)

## IDE & Tools Requirements

### Recommended IDEs
- **Visual Studio Code** (recommended)
  - Flutter extension
  - Dart extension
  - Live Share extension (optional)
  
- **Android Studio**
  - Flutter plugin
  - Dart plugin

### Command Line Tools
- **Git**: 2.0 or later
- **Xcode** (for iOS development on macOS)
- **Android SDK**: API level 21 or higher
- **Android NDK** (optional, for native development)

## Platform-Specific Requirements

### Android Development
- **Minimum API Level**: 21 (Android 5.0)
- **Target API Level**: Latest stable
- **Android Studio**: Version 4.1 or higher
- **Java Development Kit (JDK)**: 11 or higher

### iOS Development
- **Minimum iOS Version**: 11.0 or later
- **Xcode**: 14.0 or higher
- **CocoaPods**: 1.11 or higher
- **Apple Developer Account** (for app distribution)

### Windows Development
- **Visual Studio**: 2019 or later (with C++ development tools)
- **Windows SDK**: Version 19041 or higher

### macOS Development
- **macOS SDK**: Latest version
- **Xcode**: 14.0 or higher

### Linux Development
- **GCC/Clang**: 7.0 or higher
- **CMake**: 3.10 or higher
- **GTK**: 3.0 or higher

### Web Development
- **Chrome** or **Chromium** (for testing)
- **Dart Web Support** (pre-installed with Flutter)

## Project Dependencies

### Production Dependencies
```
flutter: sdk
  - Flutter framework

cupertino_icons: ^1.0.8
  - iOS style icons
```

### Development Dependencies
```
flutter_test: sdk
  - Flutter testing framework

flutter_lints: ^5.0.0
  - Dart linting and code quality
```

## Development Environment Setup

### Step 1: Install Flutter
1. Download the Flutter SDK from [flutter.dev](https://flutter.dev)
2. Extract to a suitable location
3. Add Flutter to your PATH

### Step 2: Install Platform Tools
- **Android**: Download and install Android Studio
- **iOS**: Install Xcode from App Store (macOS only)
- **Windows**: Install Visual Studio with C++ tools
- **Linux**: Install required packages via package manager

### Step 3: Install IDE Extensions
- Install Flutter and Dart extensions in your IDE
- Configure the Flutter SDK path in your IDE settings

### Step 4: Verify Installation
Run the following command:
```bash
flutter doctor
```

This will verify all requirements and list any missing tools.

## Project Configuration

### Supported Platforms
- ✅ Android
- ✅ iOS
- ✅ Windows
- ✅ macOS
- ✅ Linux
- ✅ Web

## Java Requirements (for Android)
- **JDK Version**: 11 or higher
- Ensure JAVA_HOME environment variable is set

## Important Notes

1. **Flutter Channel**: Currently on stable channel (recommended)
2. **Dart Version**: Version 3.8.1 or higher
3. **Package Management**: Uses pub.dev for package management
4. All dependencies are listed in `pubspec.yaml`

## Getting Started After Setup

1. Clone/navigate to the project directory
2. Run: `flutter pub get`
3. Run: `flutter run`

For more information, visit [Flutter Documentation](https://docs.flutter.dev)
