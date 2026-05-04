import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/screens/splash_screen.dart';
import 'package:bloodlink_donor_mobile_app/screens/welcome_screen.dart';
import 'package:bloodlink_donor_mobile_app/screens/home_screen.dart';
import 'package:bloodlink_donor_mobile_app/screens/campaigns_screen.dart';
import 'package:bloodlink_donor_mobile_app/screens/urgent_screen.dart';
import 'package:bloodlink_donor_mobile_app/screens/history_screen.dart';
import 'package:bloodlink_donor_mobile_app/screens/profile_screen.dart';
import 'package:bloodlink_donor_mobile_app/screens/badges_screen.dart';
import 'package:bloodlink_donor_mobile_app/screens/leaderboard_screen.dart';
import 'package:bloodlink_donor_mobile_app/screens/edit_profile_screen.dart';
import 'package:bloodlink_donor_mobile_app/screens/about_us_screen.dart';
import 'package:bloodlink_donor_mobile_app/screens/privacy_policy_screen.dart';
import 'package:bloodlink_donor_mobile_app/screens/terms_of_service_screen.dart';
import 'package:bloodlink_donor_mobile_app/screens/login_screen.dart';
import 'package:bloodlink_donor_mobile_app/screens/sign_up_screen.dart';
import 'package:bloodlink_donor_mobile_app/screens/test_results_screen.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';

void main() {
  runApp(const BloodLinkApp());
}

class BloodLinkApp extends StatelessWidget {
  const BloodLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BloodLink Donor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          background: AppColors.background,
          surface: AppColors.surface,
          onPrimary: AppColors.white,
          onSecondary: AppColors.white,
          onBackground: AppColors.textPrimary,
          onSurface: AppColors.textPrimary,
        ),
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
        textTheme: AppTextStyles.textTheme,
        iconTheme: const IconThemeData(color: AppColors.iconColor),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: AppTextStyles.heading,
          iconTheme: IconThemeData(color: AppColors.textPrimary),
        ),
      ),
      home: const SplashScreen(),
      routes: {
        '/splash': (_) => const SplashScreen(),
        '/welcome': (_) => const WelcomeScreen(),
        '/home': (_) => const MainNavigationScreen(),
        '/campaigns': (_) => const CampaignsScreen(),
        '/urgent': (_) => const UrgentScreen(),
        '/history': (_) => const HistoryScreen(),
        '/profile': (_) => const MainNavigationScreen(),
        '/profile/edit': (_) => const EditProfileScreen(),
        '/leaderboard': (_) => const LeaderboardScreen(),
        '/badges': (_) => const BadgesScreen(),
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignUpScreen(),
        '/test-results': (_) => const TestResultsScreen(),
        '/about': (_) => const AboutUsScreen(),
        '/privacy': (_) => const PrivacyPolicyScreen(),
        '/terms': (_) => const TermsOfServiceScreen(),
      },
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    CampaignsScreen(),
    UrgentScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        height: 70,
        backgroundColor: AppColors.white,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.campaign_outlined),
            selectedIcon: Icon(Icons.campaign),
            label: 'Campaigns',
          ),
          const NavigationDestination(
            icon: Icon(Icons.priority_high_outlined),
            selectedIcon: Icon(Icons.priority_high),
            label: 'Urgent',
          ),
          const NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'History',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
