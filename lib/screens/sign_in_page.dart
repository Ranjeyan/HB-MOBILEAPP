import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:healingbee/screens/privacy_policy.dart';

import 'Mobile_number.dart';
import 'faq.dart';
import 'user_name_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenSize.height * 0.05),
              Align(
                alignment: Alignment.centerLeft, // Align the text to the left
                child: Container(
                  padding: EdgeInsets.only(top: screenSize.height * 0.03, left: 15.0),
                  child: Text(
                    "Hello there 👋",
                    style: TextStyle(
                      fontSize: 35.0,
                      fontFamily: "lufga",
                      fontWeight: FontWeight.w200,
                      color: Color(0XFF024022),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),

              Padding(
                padding: EdgeInsets.only(left: 12.0), // Add left padding to move text to the left
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w100,
                      fontFamily: "YukitaSans",
                      color: Color(0XFF024022),
                    ),
                    children: [
                      TextSpan(
                        text: "Before we proceed further,",
                      ),
                      WidgetSpan(
                        child: SizedBox(width: 8.0),
                      ),
                      TextSpan(
                        text: "let's sign in",
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenSize.height * 0.05),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 480.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    signInWithGoogle(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide(color: Colors.black),
                    ),
                    elevation: 0.0,
                    padding: EdgeInsets.symmetric(
                      horizontal: 100.0,
                      vertical: 15.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/google.png',
                        width: 30.0,
                        height: 30.0,
                      ),
                      SizedBox(width: 20.0),
                      Text(
                        'Continue with Google',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: "YukitaSans",
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenSize.height * 0.02),
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
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide(color: Colors.black),
                    ),
                    elevation: 0.0,
                    padding: EdgeInsets.symmetric(
                      horizontal: 100.0,
                      vertical: 15.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/mobile.png',
                        width: 30.0,
                        height: 30.0,
                      ),
                      SizedBox(width: 20.0),
                      Text(
                        'Continue with Mobile',
                        style: TextStyle(
                          fontSize: 14.0,
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
          Spacer(),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 15.0,
                    fontFamily: "YukitaSans",
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: "By continuing, you're agreeing to our ",
                      style: TextStyle(fontSize: 12.0),
                    ),
                    TextSpan(
                      text: "Privacy Policy",
                      style: TextStyle(
                        color: Color(0XFF024022),
                        decoration: TextDecoration.underline,
                        fontSize: 12.0,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
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
                      style: TextStyle(fontSize: 12.0),
                    ),
                    TextSpan(
                      text: "FAQ's",
                      style: TextStyle(
                        color: Color(0XFF024022),
                        fontSize: 12.0,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
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

Future<void> signInWithGoogle(BuildContext context) async {
  try {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        print("Signed in with Google: ${userCredential.user!.displayName}");

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
