import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:healingbee/screens/App_home_page.dart';
import 'package:healingbee/screens/profile_screen.dart';
import 'package:healingbee/screens/sign_in_page.dart';
import 'package:healingbee/screens/Mobile_number.dart';
import 'package:healingbee/screens/otp_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healingbee/user_data.dart';
import 'package:provider/provider.dart';

import 'path_to_user_data_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Check if the user is already signed in
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;

  await Locales.init(
      ['en', 'gu', 'hi', 'kn', 'ml', 'mr', 'pa', 'ta', 'te', 'ur']);
  runApp(
    // Wrap your app with ChangeNotifierProvider
    ChangeNotifierProvider(
      create: (context) => UserDataProvider(), // Create an instance of UserDataProvider
      child: MyApp(user: user),
    ),
  );
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
          'splash': (context) => SplashScreen(args: {}),
          'phone': (context) => MobileNumberPage(),
          'verify': (context) => MyVerify(),
          'next': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
            return AppEntryPage(userName: args['userName'], email: args['email']); // Use args
          },
          'appEntry': (context) {
            // You need to define email and args based on your logic here
            String email = user?.email ?? ''; // Use user's email if available
            Map<String, dynamic> args = {
              'userName': 'DefaultUsername', // Set a default username or fetch from somewhere
              'email': email,
            };
            return user == null
                ? HomePage()
                : AppEntryPage(userName: args['userName'], email: args['email']);
          },
          '/profile': (context) => ProfileScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/home') {
            final args = settings.arguments as Map<String, dynamic>?;
            if (args != null && args.containsKey('userName')) {
              final userName = args['userName'] as String;
              return MaterialPageRoute(
                builder: (context) => AppEntryPage(userName: userName, email: args['email']),
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
  final Map<String, dynamic> args; // Add this line

  SplashScreen({Key? key, required this.args}) : super(key: key);

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
        final userName = widget.args['userName'] as String? ?? 'DefaultUsername';
        final email = widget.args['email'] as String? ?? '';
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AppEntryPage(userName: userName, email: email),
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

