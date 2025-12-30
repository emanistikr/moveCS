import 'package:flutter/material.dart';
import '../../controller/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../controller/app_localization.dart';

class LoginAndRegistrationPage extends StatefulWidget {
  const LoginAndRegistrationPage({super.key});
  @override
  State<LoginAndRegistrationPage> createState() =>
      _LoginAndRegistrationPageState();
}

class _LoginAndRegistrationPageState extends State<LoginAndRegistrationPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLogin = true; // true per login, false per registrazione
  bool _passwordVisible = false;

  Future<void> signIn() async {
    try {
      await AuthController().signInWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );
    } on FirebaseAuthException catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> createUser() async {
    try {
      await AuthController().createUserWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );
    } on FirebaseAuthException catch (error) {
      debugPrint(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isLogin
              ? 'Login'
              : AppLocalizations.of(context)?.translate("signUp") ?? "",
        ),
        titleTextStyle: Theme.of(context).textTheme.titleLarge,
      ),
      body: Column(
        children: [
          Column(
            children: [
              SizedBox(height: 60),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  label: Text(
                    'Email',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _passwordController,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        label: Text(
                          'Password',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  ),

                  IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      isLogin ? signIn() : createUser();
                    },
                    child: Text(
                      isLogin
                          ? AppLocalizations.of(context)?.translate("signIn") ??
                                ""
                          : AppLocalizations.of(
                                  context,
                                )?.translate("createAccount") ??
                                "",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  TextButton(
                    onPressed: () => setState(() => isLogin = !isLogin),
                    child: Text(
                      isLogin
                          ? AppLocalizations.of(
                                  context,
                                )?.translate("passToCreateAccount") ??
                                ""
                          : AppLocalizations.of(
                                  context,
                                )?.translate("passToLogIn") ??
                                "",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
