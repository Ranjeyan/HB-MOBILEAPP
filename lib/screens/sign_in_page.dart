import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'App_home_page.dart';
import 'create_account.dart';
import 'forgot_pass.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

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
      backgroundColor: Color(0XFF00463C),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 150.0),
              Transform(
                transform: Matrix4.translationValues(1.0, 20.0, 0.0),
                child: Container(
                  height: 200.0,
                  width: 200.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/logo1.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  children: [
                    buildCustomInputField(
                        'assets/images/mail.png', 'Email', emailFocusNode),
                    SizedBox(height: 35.0),
                    buildPasswordInputField(),
                    SizedBox(height: 16.0),
                    buildForgotPasswordText(),
                    SizedBox(height: 20.0),
                    buildLoginStack(),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No account? ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
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
                          child: Text(
                            'Create one',
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
              SizedBox(height: 20.0),
              if (resetEmailSent)
                Text(
                  'Email has been sent to your mail. Please check your mail.',
                  style: TextStyle(
                    color: Color(0XFF00463C),
                    fontSize: 16.0,
                  ),
                ),
              SizedBox(height: 20.0),
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
                SizedBox(width: 5.0),
                SizedBox(width: 10.0),
                Container(
                  color: Colors.white,
                  width: 1.0,
                  height: 40.0,
                  margin: EdgeInsets.only(top: 10.0),
                ),
                SizedBox(width: 25.0),
                Expanded(
                  child: TextFormField(
                    controller: isPassword ? passwordController : emailController,
                    focusNode: focusNode,
                    obscureText: isPassword && !isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: label,
                      labelStyle: TextStyle(
                        color: Colors.white,
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
                          color: Color(0XFFD4AF37),
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
                    style: TextStyle(color: Color(0XFFD4AF37)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Container(
              height: 1.0,
              width: double.infinity,
              color: Colors.white,
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
          MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
        );
      },
      child: buildCustomInputField(
          'assets/images/pass.png', 'Password', passwordFocusNode,
          isPassword: true),
    );
  }

  Widget buildForgotPasswordText() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Text(
          'Forgotten your password?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            decoration: TextDecoration.underline,
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
                primary: Color(0XFFD4AF37),
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: 130.0,
                  vertical: 18.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
              ),
              child: Text(
                'Log in',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Color(0XFF00463C),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 20,
          child: Visibility(
            visible: isLoading,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0XFFF06151)),
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
        SnackBar(
          content: Text('Invalid email or password. Please try again.'),
          backgroundColor: Color(0XFFF06151),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
