import 'package:flutter/material.dart';
import 'dart:ui';
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
import 'package:bloodlink_donor_mobile_app/screens/notifications_screen.dart';
import 'package:bloodlink_donor_mobile_app/screens/blood_request_screen.dart';
import 'package:bloodlink_donor_mobile_app/screens/my_requests_screen.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/services/notification_service.dart';
import 'package:bloodlink_donor_mobile_app/services/localization_service.dart';
import 'package:bloodlink_donor_mobile_app/services/token_refresh_service.dart';
import 'package:bloodlink_donor_mobile_app/utils/navigation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize localization (loads saved language preference)
  await LocalizationService().initialize();

  // Initialize notifications
  final notificationService = NotificationService();
  await notificationService.initialize();

  // Resume proactive token refresh if user was already logged in
  // (handles app restarts where the user has a stored valid token)
  TokenRefreshService().scheduleRefresh();

  runApp(const BloodLinkApp());
}

class BloodLinkApp extends StatelessWidget {
  const BloodLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LocalizationProvider(
      child: MaterialApp(
        navigatorKey: NavigationService.navigatorKey,
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
          cardTheme: CardThemeData(
            color: Colors.white.withOpacity(0.7),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
              side: const BorderSide(color: Color(0x55FFFFFF)),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white.withOpacity(0.7),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(24),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(24),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary.withOpacity(0.35)),
              borderRadius: BorderRadius.circular(24),
            ),
          ),
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
          '/notifications': (_) => const NotificationsScreen(),
          '/about': (_) => const AboutUsScreen(),
          '/privacy': (_) => const PrivacyPolicyScreen(),
          '/terms': (_) => const TermsOfServiceScreen(),
          '/blood-request': (_) => const BloodRequestScreen(),
          '/my-requests': (_) => const MyRequestsScreen(),
        },
      ),
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
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF2F5FF), Color(0xFFFDF3F8), Color(0xFFEFF8FF)],
          ),
        ),
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onItemTapped,
              height: 74,
              backgroundColor: Colors.white.withOpacity(0.72),
              indicatorColor: AppColors.primary.withOpacity(0.16),
              labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
              destinations: [
                NavigationDestination(
                  icon: const Icon(Icons.home_outlined),
                  selectedIcon: const Icon(Icons.home),
                  label: context.tr('nav_home'),
                ),
                NavigationDestination(
                  icon: const Icon(Icons.campaign_outlined),
                  selectedIcon: const Icon(Icons.campaign),
                  label: context.tr('nav_campaigns'),
                ),
                NavigationDestination(
                  icon: const Icon(Icons.notifications_active_outlined),
                  selectedIcon: const Icon(Icons.notifications_active),
                  label: context.tr('nav_urgent'),
                ),
                NavigationDestination(
                  icon: const Icon(Icons.history_outlined),
                  selectedIcon: const Icon(Icons.history),
                  label: context.tr('nav_history'),
                ),
                NavigationDestination(
                  icon: const Icon(Icons.person_outline),
                  selectedIcon: const Icon(Icons.person),
                  label: context.tr('nav_profile'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
