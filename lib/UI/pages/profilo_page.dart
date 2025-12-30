import 'package:flutter/material.dart';
import '../../controller/auth_controller.dart';

class ProfiloPage extends StatelessWidget {
  const ProfiloPage({super.key});

  Future<void> signOut() async {
    await AuthController().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Profilo Page!',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            FloatingActionButton(
              onPressed: () {
                signOut();
              },
              child: Icon(Icons.logout),
            ),
          ],
        ),
      ),
    );
  }
}
