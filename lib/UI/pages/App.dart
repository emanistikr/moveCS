import 'package:flutter/material.dart';
import 'home_page.dart';
import 'wallet_page.dart';
import 'notifiche_page.dart';
import 'profilo_page.dart';
import '../../config/app_colors.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    HomePage(),
    WalletPage(),
    NotifichePage(),
    ProfiloPage(),
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

        bottomNavigationBar: NavigationBar(
          height: 69,
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              selectedIcon: Icon(
                Icons.home,
                size: 29,
                color: AppColors.secondary,
              ),
              icon: Icon(Icons.home_outlined, size: 29),
              label: "Home",
            ),
            NavigationDestination(
              selectedIcon: Icon(
                Icons.account_balance_wallet,
                size: 29,
                color: AppColors.secondary,
              ),
              icon: Icon(Icons.account_balance_wallet_outlined, size: 29),
              label: "Wallet",
            ),
            NavigationDestination(
              selectedIcon: Icon(
                Icons.notifications,
                size: 29,
                color: AppColors.secondary,
              ),
              icon: Icon(Icons.notifications_outlined, size: 29),
              label: "Notifiche",
            ),
            NavigationDestination(
              selectedIcon: Icon(
                Icons.person,
                size: 29,
                color: AppColors.secondary,
              ),
              icon: Icon(Icons.person_outline, size: 29),
              label: "Profilo",
            ),
          ],
        ),
      ),
    );
  }
}
