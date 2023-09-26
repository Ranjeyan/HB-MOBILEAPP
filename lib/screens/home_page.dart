import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:healingbee/screens/terms_of_use.dart';

import 'Mobile_number.dart';
import 'faq.dart';
import 'next.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 80.0, right: 200),
                    child: Text(
                      "Hello there 👋",
                      style: TextStyle(
                        fontSize: 30.0,
                        fontFamily: "lufga",
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 40.0, left: 20.0),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 25.0,
                          fontFamily: "YukitaSans",
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: "before we proceed further,",
                          ),
                          WidgetSpan(
                            child: SizedBox(width: 5.0),
                          ),
                          TextSpan(
                            text: "let's sign in",
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 500.0),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            signInWithGoogle(context);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(color: Colors.black),
                            ),
                            elevation: 0.0,
                            padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/google.png',
                                width: 32.0,
                                height: 32.0,
                              ),
                              SizedBox(width: 30.0),
                              Text(
                                'Continue with Google',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "YukitaSans",
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.0), // Added spacing
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MobileNumberPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(color: Colors.black),
                            ),
                            elevation: 0.0,
                            padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/mobile.png',
                                width: 32.0,
                                height: 32.0,
                              ),
                              SizedBox(width: 30.0),
                              Text(
                                'Continue with Mobile',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "YukitaSans",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 9.0,
                    fontFamily: "YukitaSans",
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: "By continuing, you're agreeing to our ",
                      style: TextStyle(fontSize: 10),
                    ),
                    TextSpan(
                      text: "Privacy Policy",
                      style: TextStyle(
                        color: Colors.green,
                        decoration: TextDecoration.underline,
                        fontSize: 10,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Navigate to the Privacy Policy screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsScreen(),
                            ),
                          );
                        },
                    ),
                    TextSpan(
                      text: " & ",
                      style: TextStyle(fontSize: 10),
                    ),
                    TextSpan(
                      text: "FAQ's",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 10,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Navigate to the FAQ screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FAQPage(),
                            ),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Function to sign in with Google
Future<void> signInWithGoogle(BuildContext context) async {
  try {
    // Trigger Google Sign-In
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      // Obtain the GoogleSignInAuthentication object
      GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

      // Create an AuthCredential using the GoogleSignInAuthentication data
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Sign in to Firebase with the AuthCredential
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // Check if the user is signed in successfully
      if (userCredential.user != null) {
        print("Signed in with Google: ${userCredential.user!.displayName}");

        // Navigate to the next page using the correct context
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => NextPage(userName: userCredential.user!.displayName ?? ''),
          ),
        );
      } else {
        print("Failed to sign in with Google");
      }
    } else {
      print("Google Sign-In canceled by user");
    }
  } catch (error) {
    print("Error during Google Sign-In: $error");
  }
}
