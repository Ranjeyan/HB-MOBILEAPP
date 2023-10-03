import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import 'Mobile_number.dart';
import 'user_name_page.dart';


class MyVerify extends StatefulWidget {
  const MyVerify({Key? key}) : super(key: key);

  @override
  State<MyVerify> createState() => _MyVerifyState();
}

class _MyVerifyState extends State<MyVerify> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  var code = "";
  bool showError = false;



  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
              ),
              Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w200,color:Color(0XFF024022),fontFamily: "lufga"),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "We need to register your phone without getting started!",
                style: TextStyle(
                  fontSize: 14,
                    fontFamily: "YukitaSans",
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30,
              ),
              Pinput(
                length: 6,
                onChanged: (value) {
                  code = value;
                  setState(() {
                    showError = false; // Reset error indicator when OTP changes
                  });
                },
                showCursor: true,
                onCompleted: (pin) => print(pin),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color:  Color(0XFF024022), width: 1.0),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      PhoneAuthCredential credential = PhoneAuthProvider.credential(
                        verificationId: MobileNumberPage.verify, // Replace with your verification ID
                        smsCode: code,
                      );

                      // Sign the user in (or link) with the credential
                      await auth.signInWithCredential(credential);

                      // Navigate to the next page (NextPage widget)
                      Navigator.pushNamed(
                        context,
                        '/next',
                        arguments: {'userName': 'ran'},// Pass the userName as a route argument
                      );

                    } catch (e) {
                      // Handle any errors that occur during verification
                      print(e);
                      setState(() {
                        showError = true; // Set error indicator when OTP is incorrect
                      });
                      _showErrorSnackbar(context); // Display Snackbar
                    }
                  },
                  child: Text("Verify Phone Number",style:  TextStyle(color:Color(0XFF024022),fontFamily: "lufga" ),),
                ),
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10.0, left: 122.0), // Add padding to move it down and to the right
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          'phone',
                              (route) => false,
                        );
                      },
                      child: Text(
                        "Edit Phone Number?",
                        style: TextStyle(color: Colors.grey,fontFamily: "YukitaSans",fontSize: 12),
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

  // Function to show the error Snackbar
  void _showErrorSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Incorrect OTP. Please try again.",style: TextStyle(fontFamily: "lufga"),),
        backgroundColor:Color(0XFF024022),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/verify',
    routes: {
      '/verify': (context) => MyVerify(),
      '/next': (context) => NextPage(userName: '', email: '',),
    },
  ));
}
