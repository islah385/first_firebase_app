import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_firebase_app/scr/home_screen.dart';
import 'package:first_firebase_app/scr/signup_page.dart';
import 'package:first_firebase_app/services/firebase_auth_service.dart';
import 'package:first_firebase_app/utils/constants.dart';
import 'package:first_firebase_app/widgets/c_text_form.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  FirebaseAuthService auth = FirebaseAuthService();

  bool isLoading = false;

  void logInHandler() async {
    try {
      setState(() {
        isLoading = true;
      });

      final email = emailController.text;
      final password = passwordController.text;
      await auth.signIn(email: email, password: password);
      Fluttertoast.showToast(msg: "Success");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false,
      );
      setState(() {
        isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Log In',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.amber,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
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
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.amber),
                            foregroundColor:
                                WidgetStatePropertyAll(Colors.white)),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            logInHandler();
                          }
                        },
                        child: Text(
                          'Log In',
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
                                  builder: (context) => SignupPage(),
                                ));
                          },
                          child: Text('Sign Up'))
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
