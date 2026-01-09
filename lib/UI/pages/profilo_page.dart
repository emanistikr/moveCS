import 'package:flutter/material.dart';
import '../../config/widget_decoration/widget_styles.dart';
import '../../controller/app_localization.dart';
import '../../controller/auth_controller.dart';

class ProfiloPage extends StatefulWidget {
  final VoidCallback? onBack;

  // Aggiungi questi parametri per gestire lo stato attuale e i cambiamenti
  final bool isDarkMode;
  final Locale currentLocale;
  final ValueChanged<bool>? onThemeChanged;
  final ValueChanged<Locale>? onLanguageChanged;

  const ProfiloPage({
    super.key,
    this.onBack,
    // Valori di default o passati dal padre
    this.isDarkMode = false,
    this.currentLocale = const Locale('it'),
    this.onThemeChanged,
    this.onLanguageChanged,
  });

  @override
  State<ProfiloPage> createState() => _ProfiloPageState();
}

class _ProfiloPageState extends State<ProfiloPage> {
  AuthController controller = AuthController();
  String nomeUtente = "Utente";
  String urlImmagine =
      //Imagine con foto soggetto
      //'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=500&q=80';
      //Icona generica utente
      'https://cdn.pixabay.com/photo/2023/02/18/11/00/icon-7797704_640.png';

  late bool _isDark;
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _isDark = widget.isDarkMode;
    _locale = widget.currentLocale;
    recuperaDati();
  }

  @override
  void didUpdateWidget(covariant ProfiloPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isDarkMode != oldWidget.isDarkMode) {
      _isDark = widget.isDarkMode;
    }
    if (widget.currentLocale != oldWidget.currentLocale) {
      _locale = widget.currentLocale;
    }
  }

  Future<void> signOut() async {
    await AuthController().signOut();
  }

  Future<void> recuperaDati() async {
    String? verify = await controller.getUserName(await controller.getUid());
    setState(() {
      nomeUtente = verify ?? "Utente";
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                top: 50,
                bottom: 25,
                left: 20,
                right: 20,
              ),
              width: double.infinity,
              decoration: WidgetStyles.cardDecoration(context),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: widget.onBack,
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: colorScheme.primary,
                          size: 22,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(
                                context,
                              )?.translate('profilo_text') ??
                              "My profile",
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium!.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(urlImmagine),
                      ),
                      GestureDetector(
                        onTap: () => print("Tasto edit premuto"),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: colorScheme.primary.withAlpha(180),
                          child: const Icon(
                            Icons.edit_outlined,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "${AppLocalizations.of(context)?.translate('Hi') ?? 'Hi'}, $nomeUtente",
                    style: TextStyle(
                      color: colorScheme.onSecondary,
                      fontFamily: 'OpenSans',
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  InkWell(
                    onTap: signOut,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${AppLocalizations.of(context)?.translate('NotYou') ?? 'Not'} $nomeUtente? ",
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "${AppLocalizations.of(context)?.translate('logOut') ?? 'log out'}",
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Icon(
                          Icons.logout,
                          color: colorScheme.primary,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  //selettore tema scuro/chiaro
                  SwitchListTile(
                    title: Text(
                      AppLocalizations.of(context)?.translate('darkMode') ??
                          "Dark Mode",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    secondary: Icon(
                      _isDark ? Icons.dark_mode : Icons.light_mode,
                      color: colorScheme.primary,
                    ),
                    value: _isDark,
                    activeColor: colorScheme.primary,
                    onChanged: (val) {
                      setState(() => _isDark = val);
                      if (widget.onThemeChanged != null) {
                        widget.onThemeChanged!(val);
                      }
                    },
                  ),

                  Divider(color: Colors.grey.withAlpha(50)),

                  //selettore lingua
                  ListTile(
                    title: Text(
                      AppLocalizations.of(context)?.translate('language') ??
                          "Language",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    leading: Icon(Icons.language, color: colorScheme.primary),
                    trailing: DropdownButton<Locale>(
                      value: _locale,
                      underline: Container(), // Rimuove la linea sotto
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: colorScheme.primary,
                      ),
                      onChanged: (Locale? newLocale) {
                        if (newLocale != null) {
                          setState(() => _locale = newLocale);
                          if (widget.onLanguageChanged != null) {
                            widget.onLanguageChanged!(newLocale);
                          }
                        }
                      },
                      items: const [
                        DropdownMenuItem(
                          value: Locale('it', ''),
                          child: Text("Italiano 🇮🇹"),
                        ),
                        DropdownMenuItem(
                          value: Locale('en', ''),
                          child: Text("English 🇬🇧"),
                        ),
                      ],
                    ),
                  ),

                  Divider(color: Colors.grey.withAlpha(50)),
                  const SizedBox(height: 50),

                  // Pulsante elimina account
                  InkWell(
                    onTap: controller.deleteAccount,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${AppLocalizations.of(context)?.translate('wantToDelete') ?? 'Wanna break my heart 💔?'} ",
                          style: TextStyle(
                            color: colorScheme.error,
                            fontSize: 14,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            AppLocalizations.of(
                                  context,
                                )?.translate('deleteAccount') ??
                                'Delete Account',
                            overflow:
                                TextOverflow.ellipsis, //Come gestisce overflow
                            style: TextStyle(
                              color: colorScheme.error,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Icon(Icons.delete, color: colorScheme.error, size: 14),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
