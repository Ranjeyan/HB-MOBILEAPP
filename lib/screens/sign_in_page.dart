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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/front_image.png',
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            SizedBox(height: 60.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Sign-in to proceed",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "ReadexPro",
                      color: Color(0XFF024022),
                    ),
                  ),
                  SizedBox(height: 40.0),
                  ElevatedButton(
                    onPressed: () {
                      signInWithGoogle(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0XFF024022),
                      foregroundColor: Color(0XFF024022),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13.0),
                        side: BorderSide(color: Colors.black),
                      ),
                      elevation: 0.0,
                      padding: EdgeInsets.symmetric(
                        horizontal: 58.0,
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
                        SizedBox(width: 16.0),
                        Text(
                          'Continue with Google',
                          style: TextStyle(
                            fontSize: 17.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Poppins",
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
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
                      backgroundColor: Color(0XFF024022),
                      foregroundColor: Color(0XFF024022),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(color: Colors.black),
                      ),
                      elevation: 0.0,
                      padding: EdgeInsets.symmetric(
                        horizontal: 58.0,
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
                        SizedBox(width: 16.0),
                        Text(
                          'Continue with Mobile',
                          style: TextStyle(
                            fontSize: 17.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Poppins",
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
              padding: const EdgeInsets.all(20.0),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 15.0,
                    fontFamily: "ReadexPro",
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
                            MaterialPageRoute(builder: (context) => DetailsScreen()),
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
          ],
        ),
      ),
    );
  }
}

Future<void> signInWithGoogle(BuildContext context) async {
  try {
    // Sign out the user first
    await signOutGoogle();

    // Then, sign in with a new Google account
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

        String userEmail = userCredential.user!.email ?? ''; // Fetch email

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => NextPage(userName: userCredential.user!.displayName ?? '', email: userEmail), // Pass email to NextPage
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



Future<void> signOutGoogle() async {
  try {
    await GoogleSignIn().signOut();
  } catch (error) {
    print("Error during Google Sign-Out: $error");
  }
}
