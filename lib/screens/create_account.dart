import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healingbee/screens/sign_in_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

      // Set the display name for the user
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
            content: Text(errorMessage),
            backgroundColor: Color(0XFFF06151),
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF00463C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              SizedBox(height: 10.0),
              Text(
                'Create an\nAccount',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 60.0),
              InputField(label: 'Enter your full name', labelColor: Color(0XFFD4AF37), controller: nameController),
              SizedBox(height: 30.0),
              InputField(label: 'Email', labelColor: Color(0XFFD4AF37), controller: emailController),
              SizedBox(height: 30.0),
              InputField(label: 'Password', labelColor: Color(0XFFD4AF37), controller: passwordController, isPassword: true),
              SizedBox(height: 60.0),
              ElevatedButton(
                onPressed: signUp,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Color(0XFFD4AF37),
                  foregroundColor: Color(0XFF00463C),
                  padding: EdgeInsets.symmetric(
                    horizontal: 110.0,
                    vertical: 16.0,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                ),
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Color(0XFFD4AF37),
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
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
          padding: const EdgeInsets.only(left: 20.0,right: 20),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: isFocused ? Color(0XFFD4AF37) :Color(0XFFD4AF37), // Change border color when focused
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8.0), // Rounded corners
            ),
            child: TextFormField(
              controller: widget.controller,
              obscureText: widget.isPassword,
              style: TextStyle(
                color: Colors.black, // Text color inside the box
              ),
              cursorColor: Color(0XFFD4AF37),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0), // Padding inside the box
                hintText: widget.label,
                hintStyle: TextStyle(color: widget.labelColor),
                border: InputBorder.none, // Remove the default border
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0XFFD4AF37), // Change border color when focused
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
