import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:healingbee/screens/faq.dart';
import 'package:healingbee/screens/home_page_content.dart';
import 'package:healingbee/screens/loginpage.dart';
import 'package:healingbee/screens/signuppage.dart';
import 'package:healingbee/screens/terms_of_use.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Locales.init(['en', 'gu', 'hi', 'kn', 'ml', 'mr', 'pa', 'ta', 'te', 'ur']);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LocaleBuilder(
      builder: (locale) => MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: Locales.delegates,
        supportedLocales: Locales.supportedLocales,
        locale: locale,
        home: const SplashScreen(),
        onGenerateRoute: (settings) {
          if (settings.name == '/home') {
            final args = settings.arguments as Map<String, dynamic>?;
            if (args != null && args.containsKey('languageName')) {
              return MaterialPageRoute(
                builder: (context) => HomePage(initialLanguage: args['languageName']),
              );
            }
          }
          return null;
        },
      ),
    );
  }
}




class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoAnimation;
  late Animation<double> _buttonsAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: -20.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5),
      ),
    );

    _buttonsAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0),
      ),
    );

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(seconds: 5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter, // Start at the top center
                end: Alignment.bottomCenter, // End at the bottom center
                colors: [
                  Colors.white,
                  Color(0xFFC8FCE3), // ABF5D2
                ],
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedBuilder(
                              animation: _controller,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(0.0, _logoAnimation.value),
                                  child: child!,
                                );
                              },
                              child: Image.asset(
                                'assets/images/logo.png',
                                height: 150.0,
                              ),
                            ),
                            AnimatedBuilder(
                              animation: _controller,
                              builder: (context, child) {
                                return Opacity(
                                  opacity: _buttonsAnimation.value,
                                  child: child!,
                                );
                              },
                              child: Column(
                                children: [
                                  const SizedBox(height: 20),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.9,
                                    height: 70.0,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10.0,
                                    ),
                                    child: MaterialButton(
                                      color: Color(0xFF37AC6C),
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                          color: Color(0xFF37AC6C),
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const LoginScreen(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "Login",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.9,
                                    height: 70.0,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10.0,
                                    ),
                                    child: MaterialButton(
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                          color: Color(0xFF37AC6C),
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const RegisterScreen(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "Register",
                                        style: TextStyle(
                                          color: Color(0xFF37AC6C),
                                          fontSize: 16,
                                        ),
                                      ),
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
                // Position the text near the bottom
                Positioned(
                  bottom: 30.0,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                          ),
                          children: [
                            TextSpan(
                              text: "By creating an account, you accept the\n",
                            ),
                            TextSpan(
                              text: "Terms & Conditions",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: Color(0XFF287B53), // Change color to blue for underlined text
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Handle navigation to the terms & conditions page
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>  DetailsScreen(),
                                    ),
                                  );
                                },
                            ),
                            TextSpan(
                              text: " and ",
                            ),
                            TextSpan(
                              text: "FAQ's",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: Color(0XFF287B53), // Change color to blue for underlined text
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Handle navigation to the FAQ's page
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

