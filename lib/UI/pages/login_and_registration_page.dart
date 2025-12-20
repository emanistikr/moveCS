import 'package:flutter/material.dart';
import '../../config/app_text_styles.dart';
import '../../controller/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future<void> signIn() async {
    try{
      await AuthController().signInWithEmailAndPassword(_emailController.text,_passwordController.text);
    } on FirebaseAuthException catch (error){}
  }

  Future<void> createUser() async {
    try{
      await AuthController().createUserWithEmailAndPassword(_emailController.text,_passwordController.text);
    } on FirebaseAuthException catch (error){}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? 'Login' : 'Registrazione'),
        titleTextStyle: AppTextStyles.title,
      ),
      body: Column(
          children: [
            Column(
              children: [
                const SizedBox(height: 60),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    label: Text('Email', style: AppTextStyles.smallTitle),
                  ),
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(

                    label: Text('Password',style: AppTextStyles.smallTitle),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Column(
              children: [
                ElevatedButton(onPressed: (){
                  isLogin ? signIn() : createUser();
                }, child: Text(
                  isLogin ? 'Accedi' : 'Crea Account',
                  style: AppTextStyles.smallTitle ,
                )
                ),
                TextButton(
                  onPressed: () => setState(() => isLogin = !isLogin),
                  child: Text(isLogin ? 'Crea un nuovo account' : 'Hai già un account? Accedi'),
                ),
              ],
            ),
          ],
        ),
    );
  }
}
