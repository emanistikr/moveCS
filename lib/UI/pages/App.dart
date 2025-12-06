import 'package:flutter/material.dart';
import 'home_page.dart';
import 'wallet_page.dart';
import 'notifiche_page.dart';
import 'profilo_page.dart';
import '../../config/widget_decoration/widget_styles.dart';
import '../../controller/app_localization.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int selectedIndex = 0;

  final List<Widget> pages = [
    HomePage(),
    const WalletPage(),
    const NotifichePage(),
    const ProfiloPage(),
  ];

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
        body: pages[selectedIndex],
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
                selectedIcon: Icon(Icons.home, size: 29),
                icon: Icon(Icons.home_outlined, size: 29),
                label: AppLocalizations.of(context)?.translate("home") ?? "",
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.account_balance_wallet, size: 29),
                icon: Icon(Icons.account_balance_wallet_outlined, size: 29),
                label: AppLocalizations.of(context)?.translate("wallet") ?? "",
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.notifications, size: 29),
                icon: Icon(Icons.notifications_outlined, size: 29),
                label: AppLocalizations.of(context)?.translate("notifications") ?? "",
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.person, size: 29),
                icon: Icon(Icons.person_outline, size: 29),
                label: AppLocalizations.of(context)?.translate("profile") ?? "",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
