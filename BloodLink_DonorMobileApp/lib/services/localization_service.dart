import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationService extends ChangeNotifier {
  static const String _prefKey = 'app_locale';

  static const Map<String, String> supportedLanguages = {
    'en': 'English',
    'am': 'አማርኛ',
    'om': 'Oromiffa',
    'ti': 'ትግርኛ',
    'so': 'Soomaali',
  };

  static const Map<String, String> languageFlags = {
    'en': '🇬🇧',
    'am': '🇪🇹',
    'om': '🇪🇹',
    'ti': '🇪🇹',
    'so': '🇸🇴',
  };

  String _currentLocale = 'en';
  Map<String, String> _strings = {};

  String get currentLocale => _currentLocale;

  String get currentLanguageName =>
      supportedLanguages[_currentLocale] ?? 'English';

  static final LocalizationService _instance = LocalizationService._internal();
  factory LocalizationService() => _instance;
  LocalizationService._internal();

  /// Load saved locale and strings on app start.
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefKey) ?? 'en';
    await _load(saved);
  }

  /// Switch to a new locale and persist the choice.
  Future<void> setLocale(String locale) async {
    if (!supportedLanguages.containsKey(locale)) return;
    if (locale == _currentLocale && _strings.isNotEmpty) return;
    await _load(locale);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, locale);
  }

  Future<void> _load(String locale) async {
    try {
      final raw =
          await rootBundle.loadString('assets/locals/$locale.json');
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      _strings = decoded.map((k, v) => MapEntry(k, v.toString()));
      _currentLocale = locale;
      notifyListeners();
    } catch (_) {
      if (_strings.isEmpty) {
        _strings = {};
        _currentLocale = 'en';
      }
    }
  }

  /// Translate a key. Supports simple {placeholder} substitution.
  String tr(String key, {Map<String, String>? args}) {
    String value = _strings[key] ?? key;
    if (args != null) {
      args.forEach((placeholder, replacement) {
        value = value.replaceAll('{$placeholder}', replacement);
      });
    }
    return value;
  }

  /// Static helper: get the service from context.
  static LocalizationService of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_LocalizationInheritedWidget>()!
        .service;
  }
}

/// InheritedWidget that makes [LocalizationService] accessible via context.
class _LocalizationInheritedWidget extends InheritedWidget {
  final LocalizationService service;

  const _LocalizationInheritedWidget({
    required this.service,
    required super.child,
  });

  @override
  bool updateShouldNotify(_LocalizationInheritedWidget old) => true;
}

/// Root widget that provides [LocalizationService] to the tree and rebuilds
/// on locale change.
class LocalizationProvider extends StatefulWidget {
  final Widget child;
  const LocalizationProvider({super.key, required this.child});

  @override
  State<LocalizationProvider> createState() => _LocalizationProviderState();
}

class _LocalizationProviderState extends State<LocalizationProvider> {
  final LocalizationService _service = LocalizationService();

  @override
  void initState() {
    super.initState();
    _service.addListener(_onLocaleChanged);
  }

  void _onLocaleChanged() => setState(() {});

  @override
  void dispose() {
    _service.removeListener(_onLocaleChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _LocalizationInheritedWidget(
      service: _service,
      child: widget.child,
    );
  }
}

/// Convenient BuildContext extension — call `context.tr('key')` anywhere.
extension AppLocalizationsExt on BuildContext {
  String tr(String key, {Map<String, String>? args}) =>
      LocalizationService.of(this).tr(key, args: args);
}
