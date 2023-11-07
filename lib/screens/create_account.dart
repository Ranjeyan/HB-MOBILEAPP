import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healingbee/screens/privacy_policy.dart';
import 'package:healingbee/screens/sign_in_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'faq.dart';

void main() {
  runApp(MaterialApp(
    home: CreateAccountPage(),
  ));
}

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordVisible = false;
  String errorMessage = '';

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signUp() async {
    final String name = nameController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user!.updateDisplayName(name);

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      _onAccountCreated(name, email);
    } catch (e) {
      print("Error signing up: $e");
      setState(() {
        if (e is FirebaseAuthException) {
          if (e.code == 'email-already-in-use') {
            errorMessage = 'Email is already in use. Please use a different email address.';
          } else {
            errorMessage = 'An error occurred while signing up. Please try again later.';
          }
        }
      });
      if (errorMessage.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage, style: TextStyle(fontFamily: 'Helvetica')),
            backgroundColor: Colors.black54,
          ),
        );
      }
    }
  }

  void _onAccountCreated(String name, String email) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }


  void _onPrivacyPolicyTapped() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsScreen(),
      ),
    );
  }

  void _onFAQTapped() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FAQPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black54,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10.0),
            const Text(
              'Create an\nAccount',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 36.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 60.0),
            InputField(label: 'Enter your full name', labelColor: Colors.black54, controller: nameController),
            SizedBox(height: 30.0),
            InputField(label: 'Enter your email', labelColor: Colors.black54, controller: emailController),
            SizedBox(height: 30.0),
            InputField(label: 'Password', labelColor: Colors.black54, controller: passwordController, isPassword: true),
            SizedBox(height: 60.0),
            ElevatedButton(
              onPressed: signUp,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.black,
                foregroundColor: Colors.white38,
                padding: const EdgeInsets.symmetric(
                  horizontal: 110.0,
                  vertical: 16.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'Helvetica',
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: TextStyle(color: Colors.black54, fontSize: 16.0, fontFamily: 'Helvetica'),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'Helvetica'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'By creating an account, you accept our',
                style: TextStyle(
                  color: Colors.black54,
                  fontFamily: 'Helvetica',
                ),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _onPrivacyPolicyTapped,
                      child: const Text(
                        'privacy policy',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Helvetica',
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    Text(' & '),
                    GestureDetector(
                      onTap: _onFAQTapped,
                      child: const Text(
                        "faq's",
                        style: TextStyle(
                          color: Colors.black, // Customize the link color
                          fontFamily: 'Helvetica',
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InputField extends StatefulWidget {
  final String label;
  final Color labelColor;
  final TextEditingController? controller;
  final bool isPassword;

  InputField({required this.label, required this.labelColor, this.controller, this.isPassword = false});

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: isFocused ? Colors.white38 : Colors.black54,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: TextFormField(
              controller: widget.controller,
              obscureText: widget.isPassword,
              style: const TextStyle(
                color: Colors.black,
              ),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                hintText: widget.label,
                hintStyle: TextStyle(color: widget.labelColor),
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onTap: () {
                setState(() {
                  isFocused = true;
                });
              },
              onFieldSubmitted: (value) {
                setState(() {
                  isFocused = false;
                });
              },
            ),
          ),
        ),
        SizedBox(height: 10.0),
      ],
    );
  }
}
