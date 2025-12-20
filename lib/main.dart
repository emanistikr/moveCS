import 'package:flutter/material.dart';
import 'UI/pages/app.dart';
import 'config/app_theme.dart';
import 'config/app_constants.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'controller/app_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'controller/auth_controller.dart';
import 'UI/pages/profilo_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('it'), Locale('en')],
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      debugShowCheckedModeBanner: false,
      //Verifica se l'utente ha già effettuato l'accesso e su questo
      //decide cosa svolgere
      home: StreamBuilder(
        stream: authController().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const App();
          } else {
            return ProfiloPage();
          }
        },
      ),
    );
  }
}
