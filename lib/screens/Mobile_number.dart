import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class MobileNumberPage extends StatefulWidget {
  const MobileNumberPage({Key? key}) : super(key: key);

  static String verify = "";

  @override
  State<MobileNumberPage> createState() => _MobileNumberPage();
}

class _MobileNumberPage extends State<MobileNumberPage> {
  TextEditingController countryController = TextEditingController();
  var phone = "";

  bool _loading = false; // Add this variable to control the loader.
  final phoneNumberController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    countryController.text = "+91";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: _loading, // Show loader when _loading is true.
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 25),
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                ),
                Text(
                  "Please enter your mobile number",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w200, fontFamily: "lufga"),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Continue with a mobile number",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontFamily: "YukitaSans",
                  ),
                  textAlign: TextAlign.center,
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      // Elements you want to move here
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 65,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 40,
                        child: TextField(
                          controller: countryController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Text(
                        "|",
                        style: TextStyle(fontSize: 45, color: Colors.grey),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            phone = value;
                          },
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Phone",
                            hintStyle: TextStyle(fontFamily: "lufga"),
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
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SizedBox(
          width: double.infinity,
          height: 70,
          child: ElevatedButton(
            onPressed: () async {
              setState(() {
                _loading = true; // Show the loader when the button is pressed.
              });

              // Your Firebase phone verification code here.

              await FirebaseAuth.instance.verifyPhoneNumber(
                phoneNumber: '${countryController.text + phone}',
                verificationCompleted: (PhoneAuthCredential credential) {},
                verificationFailed: (FirebaseAuthException e) {
                  if (e.code == 'too-many-requests') {
                    print('SMS verification rate limit exceeded. Please try again later.');
                  } else {
                    print('Verification failed: ${e.message}');
                  }
                  setState(() {
                    _loading = false; // Hide the loader when the verification fails.
                  });
                },
                codeSent: (String verificationId, int? resendToken) {
                  MobileNumberPage.verify = verificationId;
                  Navigator.pushNamed(context, 'verify').then((_) {
                    setState(() {
                      _loading = false; // Hide the loader when navigation is complete.
                    });
                  });
                },
                codeAutoRetrievalTimeout: (String verificationId) {},
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              onPrimary: Colors.black,
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(color: Colors.black, width: 1.0),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 70,
              child: Center(
                child: Text(
                  "Send the code",
                  style: TextStyle(fontFamily: "lufga", fontSize: 18),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
