import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:healingbee/screens/App_home_page.dart';
import 'package:healingbee/screens/sign_in_page.dart';
import 'package:healingbee/screens/Mobile_number.dart';
import 'package:healingbee/screens/otp_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Check if the user is already signed in
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;

  await Locales.init(
      ['en', 'gu', 'hi', 'kn', 'ml', 'mr', 'pa', 'ta', 'te', 'ur']);
  runApp(MyApp(user: user));
}

class MyApp extends StatelessWidget {
  final User? user;

  const MyApp({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LocaleBuilder(
      builder: (locale) => MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: Locales.delegates,
        supportedLocales: Locales.supportedLocales,
        locale: locale,
        // Set the initialRoute based on the user's sign-in status
        initialRoute: user == null ? 'splash' : 'appEntry',
        // Define your named routes
        routes: {
          'splash': (context) => SplashScreen(),
          'phone': (context) => MobileNumberPage(),
          'verify': (context) => MyVerify(),
          'next': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as String;
            return AppEntryPage(userName: args, user: null,);
          },
          'appEntry': (context) => user == null
              ? HomePage()
              : AppEntryPage(userName: user?.displayName ?? '', user: null,),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/home') {
            final args = settings.arguments as Map<String, dynamic>?;
            if (args != null && args.containsKey('userName')) {
              final userName = args['userName'] as String;
              return MaterialPageRoute(
                builder: (context) => AppEntryPage(userName: userName, user: null,),
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
  const SplashScreen({Key? key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoAnimation;

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

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AppEntryPage(user: null, userName: '',), // Change to the desired page
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(seconds: 5),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors.white38,
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
