#!/bin/bash

# BloodLink Donor - Branding Setup Script
# This script completes the branding setup including splash screen and app icons

set -e

echo "================================"
echo "BloodLink Donor - Setup Script"
echo "================================"
echo ""

# Step 1: Get dependencies
echo "📦 Step 1: Getting dependencies..."
flutter pub get
echo "✅ Dependencies installed"
echo ""

# Step 2: Generate splash screen
echo "🎨 Step 2: Generating splash screen..."
dart run flutter_native_splash:create
echo "✅ Splash screen created"
echo ""

# Step 3: Generate app icons
echo "🖼️  Step 3: Generating app icons..."
dart run flutter_launcher_icons
echo "✅ App icons generated"
echo ""

# Step 4: Clean and rebuild
echo "🧹 Step 4: Cleaning build..."
flutter clean
echo "✅ Build cleaned"
echo ""

# Step 5: Get dependencies again
echo "📥 Step 5: Getting dependencies again..."
flutter pub get
echo "✅ Dependencies restored"
echo ""

echo "================================"
echo "✨ Setup Complete!"
echo "================================"
echo ""
echo "You can now run your app with:"
echo "  flutter run"
echo ""
echo "Or build for Android:"
echo "  flutter build apk --release"
echo ""
echo "Or build for iOS:"
echo "  flutter build ios --release"
echo ""
echo "For more details, see BRANDING_SETUP.md"
