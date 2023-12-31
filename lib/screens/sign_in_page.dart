import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'App_home_page.dart';
import 'create_account.dart';
import 'forgot_pass.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isPasswordVisible = false;
  bool isLoading = false;
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool resetEmailSent = false;

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 170.0),
              const Text(
                'LOGIN YOUR ACCOUNT',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 32.0,
                  fontFamily: 'Helvetica',
                ),
              ),
              const SizedBox(height: 90.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  children: [
                    buildCustomInputField(
                      'assets/images/mail.png',
                      'Email',
                      emailFocusNode,
                    ),
                    const SizedBox(height: 35.0),
                    buildPasswordInputField(),
                    const SizedBox(height: 16.0),
                    buildForgotPasswordText(),
                    const SizedBox(height: 20.0),
                    buildLoginStack(),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'No account? ',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16.0,
                            fontFamily: 'Helvetica',
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateAccountPage(),
                              ),
                            );
                          },
                          child: const Text(
                            'Create one',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontFamily: 'Helvetica',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              if (resetEmailSent)
                const Text(
                  'Email has been sent to your mail. Please check your mail.',
                  style: TextStyle(
                    color: Color(0XFF00463C),
                    fontSize: 16.0,
                    fontFamily: 'Helvetica',
                  ),
                ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCustomInputField(String logoAsset, String label, FocusNode focusNode,
      {bool isPassword = false}) {
    return Focus(
      onFocusChange: (hasFocus) {
        // Handle focus changes if needed
      },
      child: Container(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Image.asset(
              logoAsset,
              height: 40.0,
              width: 35.0,
            ),
            const SizedBox(width: 5.0),
            const SizedBox(width: 10.0),
            Container(
              color: Colors.black,
              width: 1.0,
              height: 40.0,
              margin: const EdgeInsets.only(top: 10.0),
            ),
            const SizedBox(width: 25.0),
            Expanded(
              child: TextFormField(
                controller: isPassword ? passwordController : emailController,
                focusNode: focusNode,
                obscureText: isPassword && !isPasswordVisible,
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: const TextStyle(
                    color: Colors.black54,
                    fontSize: 18.0,
                  ),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(bottom: 5.0),
                  suffixIcon: isPassword
                      ? IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.black54,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  )
                      : null,
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.0),
        Container(
            height: 1.0,
            width: double.infinity,
            color: Colors.black,
            margin: EdgeInsets.only(top: 0.0),
      ),
      ],
    ),
    ),
    );
  }

  Widget buildPasswordInputField() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
        );
      },
      child: buildCustomInputField(
        'assets/images/pass.png',
        'Password',
        passwordFocusNode,
        isPassword: true,
      ),
    );
  }

  Widget buildForgotPasswordText() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
        );
      },
      child: const Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: Text(
          'Forgotten your password?',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 16.0,
            decoration: TextDecoration.underline,
            fontFamily: 'Helvetica',
          ),
        ),
      ),
    );
  }

  Widget buildLoginStack() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            SizedBox(height: 40.0),
            ElevatedButton(
              onPressed: isLoading ? null : signInWithEmailAndPassword,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                primary: Colors.black,
                onPrimary: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 130.0,
                  vertical: 18.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Log in',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white38,
                  fontFamily: 'Helvetica',
                ),
              ),
            ),
          ],
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 20,
          child: Visibility(
            visible: isLoading,
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> signInWithEmailAndPassword() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    setState(() {
      isLoading = true;
    });

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AppEntryPage(user: userCredential.user),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Invalid email or password. Please try again.',
            style: TextStyle(fontFamily: 'Helvetica'),
          ),
          backgroundColor: Colors.black54,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: HomePage(),
  ));
}
