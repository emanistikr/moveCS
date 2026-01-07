import 'package:flutter/material.dart';
import 'UI/pages/app.dart';
import 'config/app_theme.dart';
import 'config/app_constants.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'controller/app_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'controller/auth_controller.dart';
//import 'UI/pages/login_and_registration_page.dart';
import 'UI/pages/login_page.dart';
import 'controller/notification_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationController().init();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  ThemeMode _themeMode = ThemeMode.system;
  Locale? _locale;

  void _toggleTheme(bool isDark) {
    setState(() {
      // Quando l'utente tocca lo switch, forziamo Scuro o Chiaro
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _changeLanguage(Locale locale) {
    setState(() {
      _locale = locale; // Qui l'utente sovrascrive l'automatico
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: _themeMode, // Usa la variabile che ora parte come 'system'

      title: AppConstants.appName,

      locale: _locale,

      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      localeResolutionCallback: (deviceLocale, supportedLocales) {
        // Se c'è una lingua manuale (_locale != null), Flutter usa quella.
        // Se _locale è null, entra qui.

        // Se il telefono ha una lingua (deviceLocale) e questa è tra quelle supportate (it o en)
        if (deviceLocale != null) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == deviceLocale.languageCode) {
              return supportedLocale; // Trovata! Usa la lingua del telefono
            }
          }
        }
        // Se il telefono è in Spagnolo/Cinese/Ecc, usiamo l'Inglese come fallback
        return supportedLocales.last;
      },

      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      supportedLocales: const [Locale('it'), Locale('en')],

      debugShowCheckedModeBanner: false,
      //Verifica se l'utente ha già effettuato l'accesso e su questo
      //decide cosa svolgere
      home: StreamBuilder(
        stream: AuthController().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // 3. CALCOLO DELLA LINGUA DA MOSTRARE
            // Dobbiamo dire alla pagina "App" quale lingua stiamo usando.
            // Se _locale è null, dobbiamo "indovinare" quale ha scelto il localeResolutionCallback
            // usando la lingua di sistema attuale.

            Locale effectiveLocale = _locale ?? const Locale('en');

            if (_locale == null) {
              // Recuperiamo la lingua del sistema
              final systemLoc =
                  WidgetsBinding.instance.platformDispatcher.locale;
              // Se è italiano, passiamo italiano, altrimenti inglese
              if (systemLoc.languageCode == 'it') {
                effectiveLocale = const Locale('it');
              }
            }

            final bool isDarkCurrently = _themeMode == ThemeMode.system
                ? MediaQuery.platformBrightnessOf(context) == Brightness.dark
                : _themeMode == ThemeMode.dark;

            return App(
              isDarkMode: isDarkCurrently,
              currentLocale: effectiveLocale,
              onThemeChanged: _toggleTheme,
              onLanguageChanged: _changeLanguage,
            );
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
