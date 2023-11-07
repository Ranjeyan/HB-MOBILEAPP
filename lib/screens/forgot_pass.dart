import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healingbee/screens/sign_in_page.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailTextController = TextEditingController();
  bool emailSent = false; // Track if the reset email has been sent

  // Define gradient colors
  Color gradientStartColor = Colors.black54;
  Color gradientEndColor = Colors.white38;

  // Widget for a Firebase UI button
  Widget firebaseUIButton(BuildContext context, String label, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          primary: Colors.white,
          side: const BorderSide(color: Colors.white),
          padding: const EdgeInsets.symmetric(vertical: 12.0),
        ),
        child: Text(label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Forgot Password",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,fontFamily: 'Helvetica'),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [gradientStartColor, gradientEndColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    controller: _emailTextController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: "Enter your email",
                      labelStyle: TextStyle(color: Colors.white,fontFamily: 'Helvetica'),
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                firebaseUIButton(context, "Reset Password",() {
                  FirebaseAuth.instance
                      .sendPasswordResetEmail(email: _emailTextController.text)
                      .then((value) {
                    setState(() {
                      emailSent = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Email has been sent to your mail. Please check your mail.', style: TextStyle(color: Color(0XFF00463C),fontFamily: 'Helvetica')),
                        backgroundColor: Colors.black54,
                      ),
                    );
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => HomePage()), // Replace 'HomePage()' with your sign-in page route
                          (Route<dynamic> route) => false, // This will remove all routes from the stack
                    );
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to reset password. Please try again.',style: TextStyle(fontFamily: 'Helvetica'),),
                        backgroundColor: Colors.black54,
                      ),
                    );
                  });
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
