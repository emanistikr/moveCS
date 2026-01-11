import 'package:flutter/material.dart';
import '../../controller/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../controller/app_localization.dart';

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

  String _errorMessage = ""; // variabile per l'errore

  Future<void> createUser() async {
    // controlliamo che nessun campo sia vuoto
    if (_nameController.text.isEmpty ||
        _surnameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      setState(
        () => _errorMessage =
            AppLocalizations.of(context)?.translate("AllFieldsRequired") ??
            "All fields are required",
      );
      return;
    }

    // Controllo lunghezza minima password
    if (_passwordController.text.length < 6) {
      setState(
        () => _errorMessage =
            AppLocalizations.of(context)?.translate("PasswordLength") ??
            "Password must be at least 6 characters long",
      );
      return;
    }
    try {
      setState(() => _errorMessage = ""); // Reset errore
      AuthController controller = AuthController();
      await controller.createUserWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );
      await controller.signInWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );
      String? uid = await controller.getUid();
      if (uid != null) {
        controller.addUserDetails(
          uid,
          _nameController.text,
          _surnameController.text,
          _emailController.text,
        );
      }
      if (context.mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } on FirebaseAuthException catch (error) {
      debugPrint(error.toString());
      setState(() {
        _errorMessage =
            AppLocalizations.of(context)?.translate("ErrorRegistering") ??
            "Error while registering. Please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.translate("signUp") ?? "Sign Up",
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        titleTextStyle: Theme.of(
          context,
        ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.person_add_rounded,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)?.translate("createAccount") ??
                    "Create Account",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),

              // Campo Nome
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context)?.translate("Name") ?? "Name",
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  //fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 16),

              // Campo Cognome
              TextField(
                controller: _surnameController,
                decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context)?.translate("Surname") ??
                      "Surname",
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  //fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 16),

              // Campo Email
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  //fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 16),

              // Campo Password
              TextField(
                controller: _passwordController,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () =>
                        setState(() => _passwordVisible = !_passwordVisible),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  //fillColor: Colors.grey[50],
                ),
              ),

              // Messaggio di errore
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    _errorMessage,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              const SizedBox(height: 40),

              // Bottone Registrazione
              ElevatedButton(
                onPressed: createUser,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  AppLocalizations.of(context)?.translate("createAccount") ??
                      "Create Account",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Torna al Login
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  AppLocalizations.of(context)?.translate("passToLogIn") ??
                      "Hai già un account? Accedi",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
