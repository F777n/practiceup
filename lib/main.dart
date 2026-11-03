import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_scope.dart';
import 'router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Убирает решётку из адреса: /calculator вместо /#/calculator.
  usePathUrlStrategy();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    CalcApp(
      theme: ThemeController(prefs),
      currencyStore: CurrencyPairStore(prefs),
    ),
  );
}

class CalcApp extends StatelessWidget {
  const CalcApp({
    super.key,
    required this.theme,
    required this.currencyStore,
  });

  final ThemeController theme;
  final CurrencyPairStore currencyStore;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: theme,
      builder: (context, _) {
        return AppScope(
          theme: theme,
          currencyStore: currencyStore,
          child: MaterialApp.router(
            title: 'Калькулятор и конвертер',
            debugShowCheckedModeBanner: false,
            theme: buildAppTheme(Brightness.light),
            darkTheme: buildAppTheme(Brightness.dark),
            themeMode: theme.mode,
            routerConfig: appRouter,
          ),
        );
      },
    );
  }
}
