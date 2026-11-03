import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'logic/currency.dart';

const _themeKey = 'theme_mode';
const _fromKey = 'converter_from';
const _toKey = 'converter_to';

class ThemeController extends ChangeNotifier {
  ThemeController(this._prefs)
      : _mode = _prefs.getString(_themeKey) == 'dark'
            ? ThemeMode.dark
            : ThemeMode.light;

  final SharedPreferences _prefs;
  ThemeMode _mode;

  ThemeMode get mode => _mode;

  void toggle() {
    _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
    _prefs.setString(
      _themeKey,
      _mode == ThemeMode.dark ? 'dark' : 'light',
    );
  }
}

class CurrencyPairStore {
  CurrencyPairStore(this._prefs);

  final SharedPreferences _prefs;

  String get fromCode => _read(_fromKey, 'USD');

  String get toCode => _read(_toKey, 'EUR');

  String _read(String key, String fallback) {
    return currencyByCode(_prefs.getString(key))?.code ?? fallback;
  }

  void save(String from, String to) {
    _prefs.setString(_fromKey, from);
    _prefs.setString(_toKey, to);
  }
}

class AppScope extends InheritedWidget {
  const AppScope({
    required this.theme,
    required this.currencyStore,
    required super.child,
    super.key,
  });

  final ThemeController theme;
  final CurrencyPairStore currencyStore;

  static AppScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope не найден');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) {
    return theme != oldWidget.theme || currencyStore != oldWidget.currencyStore;
  }
}

ThemeData buildAppTheme(Brightness brightness) {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: Colors.indigo,
    brightness: brightness,
  );
  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 2,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
  );
}
