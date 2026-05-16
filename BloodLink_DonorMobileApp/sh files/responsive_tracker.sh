#!/bin/bash

# Responsive Refactoring Automation Script
# This script helps track and complete responsive refactoring for all screens

SCREENS=(
  "welcome_screen"
  "home_screen"
  "campaigns_screen"
  "urgent_screen"
  "history_screen"
  "profile_screen"
  "leaderboard_screen"
  "edit_profile_screen"
  "test_results_screen"
)

SCREENS_DIR="lib/screens"
GUIDE_FILE="RESPONSIVE_REFACTORING_GUIDE.md"

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║     BloodLink Donor App - Responsive Refactoring Tracker       ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Check which screens still need refactoring
echo "📊 REFACTORING STATUS:"
echo "═══════════════════════════════════════════════════════════════"

COMPLETED=0
PENDING=0

for screen in "${SCREENS[@]}"; do
  FILE="$SCREENS_DIR/${screen}.dart"
  
  if [ ! -f "$FILE" ]; then
    echo "⚠️  $screen.dart - NOT FOUND"
    continue
  fi
  
  # Check if file has responsive import
  if grep -q "responsive_utils" "$FILE"; then
    echo "✅ $screen.dart - REFACTORED"
    ((COMPLETED++))
  else
    echo "⏳ $screen.dart - PENDING"
    ((PENDING++))
  fi
done

echo ""
echo "Statistics: $COMPLETED completed | $PENDING pending"
echo ""

# Show next screen to refactor
echo "📋 NEXT SCREEN TO REFACTOR:"
echo "═══════════════════════════════════════════════════════════════"

for screen in "${SCREENS[@]}"; do
  FILE="$SCREENS_DIR/${screen}.dart"
  
  if [ -f "$FILE" ] && ! grep -q "responsive_utils" "$FILE"; then
    echo ""
    echo "👉 NEXT: $screen.dart"
    echo ""
    echo "Steps to refactor:"
    echo "  1. Read the file: Open lib/screens/${screen}.dart"
    echo "  2. Import responsive utils at top:"
    echo "     import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';"
    echo "  3. In build() method, add at the start:"
    echo "     final responsive = context.responsive;"
    echo "  4. Replace all fixed dimensions using patterns in $GUIDE_FILE"
    echo "  5. Test on multiple screen sizes"
    echo ""
    echo "Quick patterns to remember:"
    echo "  • Heights → responsive.getSpacing(small: X, medium: Y, large: Z)"
    echo "  • Padding → responsive.getPadding(X)"
    echo "  • Font sizes → copyWith(fontSize: responsive.getFont(X))"
    echo "  • Border radius → BorderRadius.circular(responsive.getBorderRadius(X))"
    echo "  • Small screens → responsive.isSmallScreen ? Column : Row"
    echo ""
    break
  fi
done

echo "📖 For detailed guidance, see: $GUIDE_FILE"
echo ""
echo "✨ Happy refactoring! 🎨"
