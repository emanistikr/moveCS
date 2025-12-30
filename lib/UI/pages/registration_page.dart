import 'package:flutter/material.dart';
import '../../controller/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../controller/app_localization.dart';
import 'App.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  bool _passwordVisible = false;

  Future<void> createUser() async {
    try {
      AuthController controller = AuthController();
      await controller.createUserWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );
      await controller.signInWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );
      //Verifichiamo che registrazione e login sono andate okay
      String? uid = await controller.getUid();
      if (uid != null){
        controller.addUserDetails(
            uid,
            _nameController.text,
            _surnameController.text,
            _emailController.text
        );
      }
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => App()),
            (route) => false,
      );
    } on FirebaseAuthException catch (error) {
      debugPrint(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.translate("signUp") ?? "Sign Up"),
        titleTextStyle: Theme.of(context).textTheme.titleLarge,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 60),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                label: Text(AppLocalizations.of(context)?.translate("Name") ?? "Name", style: Theme.of(context).textTheme.bodyLarge),
              ),
            ),
            TextField(
              controller: _surnameController,
              decoration: InputDecoration(
                label: Text(AppLocalizations.of(context)?.translate("Surname") ?? "Surname", style: Theme.of(context).textTheme.bodyLarge),
              ),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                label: Text('Email', style: Theme.of(context).textTheme.bodyLarge),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _passwordController,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      label: Text('Password', style: Theme.of(context).textTheme.bodyLarge),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                ),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: createUser,
              child: Text(
                AppLocalizations.of(context)?.translate("createAccount") ?? "Create Account",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context), // Torna indietro al Login
              child: Text(AppLocalizations.of(context)?.translate("passToLogIn") ?? "Back to Login"),
            ),
          ],
        ),
      ),
    );
  }
}