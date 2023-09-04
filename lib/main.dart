import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:healingbee/screens/Policy_Page.dart';
import 'package:healingbee/screens/faq.dart';
import 'package:healingbee/screens/language_page.dart';
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

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoAnimation;
  late Animation<double> _buttonsAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Total animation duration
    );

    _logoAnimation = Tween<double>(
      begin: 0.0, // Initial position
      end: -20.0, // Final position (move up by 20 pixels)
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5), // Logo animation starts at 0% and ends at 50%
      ),
    );

    _buttonsAnimation = Tween<double>(
      begin: 0.0, // Initial opacity (invisible)
      end: 1.0, // Final opacity (fully visible)
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0), // Buttons animation starts at 50% and ends at 100%
      ),
    );

    _controller.forward(); // Start the animation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFBAFAD1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0.0, _logoAnimation.value), // Apply logo animation
                  child: child,
                );
              },
              child: Image.asset(
                'assets/images/logo.png',
                height: 150.0, // Adjust the height as needed
              ),
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _buttonsAnimation.value, // Apply buttons animation
                  child: child,
                );
              },
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Login button
                  MaterialButton(
                    color: const Color(0xFF37AC6C),
                    shape: RoundedRectangleBorder(
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
                    child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  // Register button
                  MaterialButton(
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
                    child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
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
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class HomePage extends StatefulWidget {
  final String initialLanguage;

  HomePage({required this.initialLanguage});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedLanguage = "Select Language";
  bool _termsAccepted = false;
  bool _faqAccepted = false;

  Future<void> _navigateToLanguagePage() async {
    final selectedLanguageName = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => LanguagePage()),
    );

    if (selectedLanguageName != null) {
      setState(() {
        _selectedLanguage = selectedLanguageName;
      });
    }
  }

  Future<void> _navigateToFAQPage() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => FAQPage()), // Replace with your FAQ page
    );

    setState(() {
      _faqAccepted = true; // Mark FAQs as accepted after returning from the FAQ page
    });
  }

  void _navigateToNextPage() {
    if (_termsAccepted && _faqAccepted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => PolicyPage()), // Replace with your next page
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("Please accept the Terms of Use and FAQs."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD5F3E3),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 60),
          Padding(
            padding: EdgeInsets.only(left: 25),
            child: LocaleText(
              "keep_a_diary",
              style: TextStyle(
                color: Color(0xFF2C6144),
                fontSize: 28,
                fontFamily: 'Ubuntu-M',
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.all(8),
                child: LocaleText(
                  "heading_1",
                  style: TextStyle(
                    fontFamily: 'Neue Plak',
                    fontSize: 23,
                    color: Color(0xFF37AC6C),
                  ),
                  maxLines: 10,
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.all(10),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'Neue Plak',
                      fontSize: 22,
                      color: Color(0xFF37AC6C),
                    ),
                    children: [
                      TextSpan(
                        text: "By using this application, you agree to its ",
                      ),
                      TextSpan(
                        text: "terms of use.",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Color(0xFF37AC6C)),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => DetailsScreen()),
                            );
                          },
                      ),
                    ],
                  ),
                  maxLines: 3,
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.all(10),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'Neue Plak',
                      fontSize: 22,
                      color: Color(0xFF37AC6C),
                    ),
                    children: [
                      TextSpan(
                        text: "Read our ",
                      ),
                      TextSpan(
                        text: "FAQs",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Color(0xFF37AC6C)),
                        recognizer: TapGestureRecognizer()
                          ..onTap = _navigateToFAQPage,
                      ),
                    ],
                  ),
                  maxLines: 3,
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ),
          SizedBox(height:150),
          Align(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: ElevatedButton(
                onPressed: _navigateToNextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF37AC6C), // Change the color here
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: LocaleText("continue",
                style: TextStyle(
                  fontFamily:"Ubuntu"
                ),),
              ),
            ),
          ),
          Spacer(),
          Align(
            alignment: Alignment.bottomLeft,
            child: InkWell(
              onTap: _navigateToLanguagePage,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Icon(Icons.language, size: 20),
                    SizedBox(width: 4),
                    Text(
                      _selectedLanguage.isNotEmpty
                          ? _selectedLanguage
                          : 'Select Language',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Ubuntu",
                        fontSize: 20,
                        color: Color(0xFF2C6144),
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_drop_down, size: 30),
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

