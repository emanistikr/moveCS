import 'package:flutter/material.dart';
import 'home_page.dart';
import 'wallet_page.dart';
import 'notifiche_page.dart';
import 'profilo_page.dart';
import '../../config/widget_decoration/widget_styles.dart';
import '../../controller/app_localization.dart';
import '../../controller/notification_controller.dart';

class App extends StatefulWidget {
  final bool isDarkMode;
  final Locale currentLocale;
  final ValueChanged<bool> onThemeChanged;
  final ValueChanged<Locale> onLanguageChanged;

  const App({
    super.key,
    required this.isDarkMode,
    required this.currentLocale,
    required this.onThemeChanged,
    required this.onLanguageChanged,
  });

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    NotificationController.tabIndexNotifier.addListener(() {
      setState(() {
        selectedIndex = NotificationController.tabIndexNotifier.value;
      });
    });
  }

  List<Widget> get _pages => [
    HomePage(),
    WalletPage(onBack: () => _goHome()),
    NotifichePage(onBack: () => _goHome()),
    ProfiloPage(
      onBack: () => _goHome(),
      isDarkMode: widget.isDarkMode,
      currentLocale: widget.currentLocale,
      onThemeChanged: widget.onThemeChanged,
      onLanguageChanged: widget.onLanguageChanged,
    ),
  ];

  void _goHome() {
    debugPrint("Tornando alla Home Page");
    setState(() {
      selectedIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: selectedIndex == 0,
      onPopInvoked: (didPop) {
        if (!didPop) {
          setState(() {
            selectedIndex = 0;
          });
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: IndexedStack(index: selectedIndex, children: _pages),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [WidgetStyles.shadowUpStyle(context)],
          ),
          child: NavigationBar(
            height: 69,
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            destinations: [
              NavigationDestination(
                selectedIcon: const Icon(Icons.home, size: 29),
                icon: const Icon(Icons.home_outlined, size: 29),
                label:
                    AppLocalizations.of(context)?.translate("home") ?? "Home",
              ),
              NavigationDestination(
                selectedIcon: const Icon(
                  Icons.account_balance_wallet,
                  size: 29,
                ),
                icon: const Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 29,
                ),
                label:
                    AppLocalizations.of(context)?.translate("wallet") ??
                    "Wallet",
              ),
              NavigationDestination(
                selectedIcon: const Icon(Icons.notifications, size: 29),
                icon: const Icon(Icons.notifications_outlined, size: 29),
                label:
                    AppLocalizations.of(context)?.translate("notifications") ??
                    "Notifications",
              ),
              NavigationDestination(
                selectedIcon: const Icon(Icons.person, size: 29),
                icon: const Icon(Icons.person_outline, size: 29),
                label:
                    AppLocalizations.of(context)?.translate("profile") ??
                    "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
