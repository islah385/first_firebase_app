import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_firebase_app/scr/login_page.dart';
import 'package:first_firebase_app/services/firebase_auth_service.dart';
import 'package:first_firebase_app/utils/constants.dart';
import 'package:first_firebase_app/widgets/c_text_form.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final FirebaseAuthService auth = FirebaseAuthService();

  void signUpHandler() async {
    try {
      final email = emailController.text;
      final password = passwordController.text;
      await auth.signUp(email: email, password: password);
      Fluttertoast.showToast(msg: 'Account created Successfully');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        msg: e.code,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign up'),
        backgroundColor: kPrimaryColor,
        foregroundColor: kWhite,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CTextForm(
                  controller: emailController,
                  labelT: 'Email',
                  hintT: 'Enter your email',
                  validate: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  icon: Icon(Icons.email),
                ),
                kHeight20,
                CTextForm(
                  controller: passwordController,
                  labelT: 'Passward',
                  hintT: 'Enter your password',
                  validate: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                  icon: Icon(Icons.lock),
                  obscureT: true,
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(kPrimaryColor),
                      foregroundColor: WidgetStatePropertyAll(kWhite)),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      signUpHandler();
                    }
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ));
                    },
                    child: Text('Log In'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
