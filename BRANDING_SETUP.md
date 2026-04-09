# BloodLink Donor - Branding & Launch Configuration Setup Guide

This guide walks you through setting up the splash screen, app icon, and app name for the BloodLink Donor mobile app.

## Prerequisites

Ensure you have Flutter installed and the project dependencies are up to date.

## Setup Steps

### 1. Get Dependencies

Run this command to install the required packages for splash screen and icon generation:

```bash
flutter pub get
```

This will install:
- `flutter_native_splash` - for native splash screen generation
- `flutter_launcher_icons` - for app icon generation

### 2. Generate Native Splash Screen

Generate the native splash screen for both Android and iOS:

```bash
dart run flutter_native_splash:create
```

This command will:
- Create native Android splash screens
- Create native iOS splash screens
- Auto-backup `AndroidManifest.xml` to `AndroidManifest.xml.bak`
- Display generated files

### 3. Generate App Icons

Generate all required app icon sizes for Android and iOS:

```bash
dart run flutter_launcher_icons
```

This command will:
- Generate Android launcher icons in all required sizes (mdpi, hdpi, xhdpi, xxhdpi, xxxhdpi)
- Generate iOS app icon
- Properly replace existing icons

### 4. Clean and Rebuild

After generating splash and icons, clean the build and rebuild:

```bash
flutter clean
flutter pub get
flutter run
```

## Configuration Details

### Splash Screen Configuration

**File:** `pubspec.yaml` - `flutter_native_splash` section

- **Color:** `#F6F7FB` (light app background matching theme)
- **Image:** `assets/image/app_logo.jpg`
- **Android 12+:** Adaptive splash with icon background

**Splash Screen Widget:** `lib/screens/splash_screen.dart`

- Custom animated splash screen with fade and scale animations
- Displays app logo, name ("BloodLink Donor"), and tagline ("Save Lives Today")
- Auto-navigates to welcome screen after 3 seconds
- Smooth loading indicator

### App Icon Configuration

**File:** `pubspec.yaml` - `flutter_launcher_icons` section

- **Source Icon:** `assets/image/app_logo.jpg`
- **Adaptive Icon Background:** `#F6F7FB`
- **Android:** Generates all required densities (mdpi, hdpi, xhdpi, xxhdpi, xxxhdpi)
- **iOS:** Generates app icon set
- **Min SDK:** Android 21+

Generated icons are placed in:
- Android: `android/app/src/main/res/mipmap-*/ic_launcher.png`
- iOS: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

### App Name Configuration

**Android** - `android/app/src/main/AndroidManifest.xml`
- Uses string resource `@string/app_name`
- Defined in `android/app/src/main/res/values/strings.xml`: "BloodLink Donor"

**iOS** - `ios/Runner/Info.plist`
- `CFBundleDisplayName`: "BloodLink Donor" (shown on home screen)
- `CFBundleName`: "BloodLink Donor" (internal identifier)

**Flutter** - `pubspec.yaml`
- `title`: "BloodLink Donor" (shown in app switcher/navigation)

## Navigation Flow

```
SplashScreen (3 seconds)
    ↓
WelcomeScreen
    ↓ (user action)
LoginScreen or SignUpScreen
    ↓
MainNavigationScreen (if authenticated)
```

## Assets Used

- `assets/image/app_logo.jpg` - Main logo for splash screen and app icon
- `assets/image/children_image.jpg` - Welcome screen hero image

## Building APK (Android)

To build a release APK with the new splash screen and icons:

```bash
flutter build apk --release
```

To build an App Bundle (recommended for Google Play):

```bash
flutter build appbundle --release
```

## Building for iOS

To build for iOS with the new configuration:

```bash
flutter build ios
```

Then open in Xcode and build from there, or deploy directly using:

```bash
flutter build ios --release
```

## Troubleshooting

### Splash Screen Not Showing

- Ensure `dart run flutter_native_splash:create` was run successfully
- Check that native files were generated in `android/` and `ios/`
- Run `flutter clean` and rebuild

### App Icon Not Showing

- Ensure `dart run flutter_launcher_icons` completed without errors
- Check icon files were generated in `android/app/src/main/res/mipmap-*/`
- Reinstall the app on device/emulator

### App Name Not Displaying

- For Android: Verify strings.xml exists and app_name is defined
- For iOS: Check Info.plist for CFBundleDisplayName entry
- Verify pubspec.yaml title is set correctly

## Files Modified/Created

- ✅ `lib/screens/splash_screen.dart` - Custom splash screen widget
- ✅ `lib/main.dart` - Updated to use splash screen as entry point
- ✅ `pubspec.yaml` - Added dependencies and configurations
- ✅ `android/app/src/main/res/values/strings.xml` - Android app name
- ✅ `android/app/src/main/AndroidManifest.xml` - Updated to use string resource
- ✅ `ios/Runner/Info.plist` - Updated app display names
- 📁 `android/app/src/main/res/mipmap-*/` - Generated icons (after running command)
- 📁 `ios/Runner/Assets.xcassets/AppIcon.appiconset/` - Generated icons (after running command)

## Next Steps

1. Run the setup commands above in order
2. Test the app on both Android and iOS devices/emulators
3. Verify splash screen delay and animations are smooth
4. Check app icon appears correctly on home screen
5. Verify app name displays properly
6. Test navigation flow works as expected

## Resources

- [Flutter Native Splash Documentation](https://pub.dev/packages/flutter_native_splash)
- [Flutter Launcher Icons Documentation](https://pub.dev/packages/flutter_launcher_icons)
- [Flutter App Icon Guide](https://flutter.dev/docs/deployment/flavors)
