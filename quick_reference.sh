#!/bin/bash

# Quick Reference Card for Responsive Refactoring
# Print this to terminal for quick lookup

cat << 'EOF'

╔══════════════════════════════════════════════════════════════════════════════╗
║           BLOODLINK DONOR APP - RESPONSIVE REFACTORING QUICK CARD            ║
║                     Print and Keep at Your Desk! 🎨                         ║
╚══════════════════════════════════════════════════════════════════════════════╝

┌─ CURRENT STATUS ────────────────────────────────────────────────────────────┐
│ ✅ Responsive Foundation: 100% complete                                     │
│ ✅ Custom Widgets: 100% complete (3 files)                                  │
│ ✅ Screens Refactored: 3 of 12 (splash, login, signup)                     │
│ ⏳ Overall Progress: 35% complete                                           │
└─────────────────────────────────────────────────────────────────────────────┘

┌─ NEXT TASK ─────────────────────────────────────────────────────────────────┐
│ 👉 welcome_screen.dart (Entry point for new users)                          │
│                                                                              │
│ Steps:                                                                       │
│   1. Read: REFACTOR_WELCOME_SCREEN_GUIDE.md                                │
│   2. Edit: lib/screens/welcome_screen.dart                                 │
│   3. Add: import 'package:.../responsive_utils.dart';                      │
│   4. Initialize: final responsive = context.responsive;                    │
│   5. Replace all fixed dimensions with responsive methods                   │
│   6. Test: flutter run -d chrome (test 3 sizes: 375, 600, 800dp)          │
└─────────────────────────────────────────────────────────────────────────────┘

┌─ THE 5 KEY PATTERNS ────────────────────────────────────────────────────────┐
│                                                                              │
│ 1️⃣  HEIGHTS/SPACING                                                         │
│     Before:  SizedBox(height: 24)                                          │
│     After:   SizedBox(height: responsive.getSpacing(                       │
│                small: 16, medium: 24, large: 32))                          │
│                                                                              │
│ 2️⃣  PADDING                                                                 │
│     Before:  padding: const EdgeInsets.all(20)                             │
│     After:   padding: EdgeInsets.all(responsive.getPadding(20))            │
│                                                                              │
│ 3️⃣  FONT SIZES                                                              │
│     Before:  Text('Hi', style: TextStyle(fontSize: 26))                    │
│     After:   Text('Hi', style: TextStyle(                                  │
│                fontSize: responsive.getFont(26)))                          │
│                                                                              │
│ 4️⃣  BORDER RADIUS                                                           │
│     Before:  BorderRadius.circular(18)                                     │
│     After:   BorderRadius.circular(responsive.getBorderRadius(18))         │
│                                                                              │
│ 5️⃣  CONDITIONAL LAYOUTS                                                     │
│     Before:  Row(children: [A, B])  // Always 2 columns                    │
│     After:   responsive.isSmallScreen ? Column(...) : Row(...)             │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌─ METHOD REFERENCE CARD ─────────────────────────────────────────────────────┐
│                                                                              │
│ context.responsive.isSmallScreen  // true if < 600dp                       │
│ context.responsive.isMediumScreen // true if 600-900dp                     │
│ context.responsive.isLargeScreen  // true if > 900dp                       │
│                                                                              │
│ context.responsive.getFont(base)          // Scale font sizes              │
│ context.responsive.getPadding(base)       // Scale padding/margins         │
│ context.responsive.getBorderRadius(base)  // Scale border radius           │
│ context.responsive.getSpacing(...)        // Flexible spacing by breakpoint│
│ context.responsive.getWidth(percentage)   // % of screen width             │
│ context.responsive.getHeight(percentage)  // % of screen height            │
│ context.responsive.getIconSize(base)      // Scale icon sizes              │
│ context.responsive.getElevation(base)     // Scale shadow elevation        │
│ context.responsive.getGridColumns(max:)   // Dynamic grid columns          │
│ context.responsive.getButtonHeight()      // Standard button height        │
│ context.responsive.getInputHeight()       // Standard input height         │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌─ COMMON REPLACEMENTS CHEAT SHEET ──────────────────────────────────────────┐
│                                                                              │
│ FIXED SIZE            →  RESPONSIVE REPLACEMENT                           │
│ ────────────────────────────────────────────────────────────────────────   │
│ height: 24            →  height: responsive.getSpacing(16, 24, 32)        │
│ width: 80             →  width: responsive.isSmallScreen ? 60 : 80        │
│ padding: 20           →  padding: responsive.getPadding(20)               │
│ fontSize: 14          →  fontSize: responsive.getFont(14)                 │
│ borderRadius: 12      →  borderRadius: responsive.getBorderRadius(12)     │
│ icon size: 24         →  size: responsive.getFont(24)                     │
│ elevation: 4          →  elevation: responsive.getElevation(4)            │
│                                                                              │
│ SPECIAL CASES:                                                             │
│ height: 250 (hero)    →  height: responsive.getHeight(35)  // 35% screen  │
│ gridColumns: 2        →  crossAxisCount: responsive.getGridColumns(max:2) │
│ Row side-by-side      →  responsive.isSmallScreen ? Column : Row          │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌─ DOCUMENTATION FILES ──────────────────────────────────────────────────────┐
│                                                                              │
│ 📄 README_RESPONSIVE_WORK.md                                              │
│    Master guide with everything you need to know                          │
│                                                                              │
│ 📄 RESPONSIVE_REFACTORING_SUMMARY.md                                      │
│    Project statistics, what's done, what's pending, time estimates        │
│                                                                              │
│ 📄 RESPONSIVE_REFACTORING_GUIDE.md                                        │
│    Detailed refactoring patterns with examples and explanations           │
│                                                                              │
│ 📄 REFACTOR_WELCOME_SCREEN_GUIDE.md                                       │
│    Step-by-step specific to the next screen (welcome_screen.dart)         │
│                                                                              │
│ 🔧 responsive_tracker.sh                                                  │
│    Run to see current progress: ./responsive_tracker.sh                   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌─ TESTING WORKFLOW ─────────────────────────────────────────────────────────┐
│                                                                              │
│ # After making changes, test on 3 screen sizes                            │
│ # Screen Size        │  Device              │  Width                      │
│ # ─────────────────────────────────────────────────────────────────        │
│ # Small (Phone)      │  iPhone 12/13        │  375-390 dp                │
│ # Medium (Tablet)    │  iPad Mini           │  600 dp                    │
│ # Large (Tablet Pro) │  iPad Pro 12.9"      │  800+ dp                   │
│                                                                              │
│ Quick test command:                                                        │
│ $ flutter run -d chrome                                                   │
│ Then use Chrome DevTools to resize (F12, toggle device toolbar)           │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌─ MISTAKES TO AVOID ────────────────────────────────────────────────────────┐
│                                                                              │
│ ❌ Mixing const and responsive values                                      │
│    padding: const EdgeInsets.only(left: responsive.getPadding(16))        │
│                                                                              │
│ ❌ Using getFont() for non-font dimensions                                │
│    SizedBox(width: responsive.getFont(100))  // WRONG                     │
│                                                                              │
│ ❌ Forgetting isDense: true for TextFields                                │
│    TextField(decoration: InputDecoration(...))  // Missing isDense: true   │
│                                                                              │
│ ❌ Keeping TextStyle as const when using responsive font                  │
│    const TextStyle(fontSize: responsive.getFont(14))  // Can't use const   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌─ PRIORITY QUEUE FOR NEXT SCREENS ──────────────────────────────────────────┐
│                                                                              │
│ 1. welcome_screen.dart         ← START HERE (entry point)                 │
│ 2. home_screen.dart            (main dashboard)                           │
│ 3. profile_screen.dart         (user profile)                             │
│ 4. campaigns_screen.dart                                                  │
│ 5. urgent_screen.dart                                                     │
│ 6. history_screen.dart                                                    │
│ 7. leaderboard_screen.dart                                                │
│ 8. edit_profile_screen.dart                                               │
│ 9. test_results_screen.dart                                               │
│                                                                              │
│ Estimated time per screen: 15-30 minutes                                   │
│ Total remaining: 2-4.5 hours for all 9 screens                             │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌─ QUICK COMMANDS ────────────────────────────────────────────────────────────┐
│                                                                              │
│ # Check progress                                                           │
│ $ ./responsive_tracker.sh                                                 │
│                                                                              │
│ # Format code after editing                                               │
│ $ dart format lib/screens/welcome_screen.dart                             │
│                                                                              │
│ # Check for errors                                                        │
│ $ dart analyze lib/screens/welcome_screen.dart                            │
│                                                                              │
│ # Run and test                                                            │
│ $ flutter run -d chrome                                                   │
│                                                                              │
│ # Clean build if issues                                                   │
│ $ flutter clean && flutter pub get                                        │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘

╔══════════════════════════════════════════════════════════════════════════════╗
║                         YOU'RE 35% DONE! 🚀                                  ║
║  All infrastructure is in place. The hardest part is done. Just follow the   ║
║  patterns and knock out the remaining 9 screens! Each one is similar.        ║
║  Estimated 4-6 hours to 100% responsive coverage.                           ║
╚══════════════════════════════════════════════════════════════════════════════╝

EOF
