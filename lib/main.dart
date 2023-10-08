import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:healingbee/screens/App_home_page.dart';
import 'package:healingbee/screens/hb_detaills.dart';
import 'package:healingbee/screens/profile_screen.dart';
import 'package:healingbee/screens/sign_in_page.dart';
import 'package:healingbee/user_data.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'path_to_user_data_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;

  await Locales.init(
      ['en', 'gu', 'hi', 'kn', 'ml', 'mr', 'pa', 'ta', 'te', 'ur']);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor:Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  runApp(
    ChangeNotifierProvider(
      create: (context) => UserDataProvider(),
      child: MyApp(user: user),
    ),
  );
}

class MyApp extends StatelessWidget {
  final User? user;

  const MyApp({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: Locales.delegates,
      supportedLocales: Locales.supportedLocales,
      locale: Locale('en'),
      // Set the "home" property to SplashScreen
      home: SplashScreen(user: user, args: {}),
      routes: {
        '/appEntry': (context) {
          if (user != null) {
            return AppEntryPage(user: user);
          } else {
            return HomePage();
          }
        },

        '/profile': (context) => ProfileScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          final args = settings.arguments as Map<String, dynamic>?;
          if (args != null && args.containsKey('userName')) {
            final userName = args['userName'] as String;
            return MaterialPageRoute(
              builder: (context) => AppEntryPage(
                user: null,
              ),
            );
          }
        }
        return null;
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  final User? user;

  SplashScreen({Key? key, required this.user, required Map<String, String> args}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 2), () {
      if (widget.user != null) {
        // User is logged in, retrieve their information
        final userName = widget.user?.displayName ?? 'DefaultUsername';
        final email = widget.user?.email ?? '';

        if (email.isEmpty) {
          // User is not logged in, navigate to DetailScreen
          navigateToDetailScreen();
        } else {
          // User is logged in, navigate to AppEntryPage with actual values
          Navigator.pushReplacementNamed(context, '/appEntry');
        }
      } else {
        // User is not logged out, navigate to DetailScreen
        navigateToDetailScreen();
      }
    });
  }

  void navigateToDetailScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isNewUser = prefs.getBool('isNewUser') ?? true;

    if (isNewUser) {
      // User is a new user, navigate to DetailScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DetailScreen(userName: '', email: ''),
        ),
      );
    } else {
      // User is an existing user, navigate to AppEntryPage
      Navigator.pushReplacementNamed(context, '/appEntry');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF00463C),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Image.asset(
                'assets/images/logo1.png',
                height: 200.0,
              ),
            ),
            SizedBox(height: 20.0),
            Transform.scale(
              scale: 0.3,
              child: LoadingIndicator(
                indicatorType: Indicator.ballClipRotateMultiple,
                colors: const [Color(0XFFFFC986)],
                strokeWidth: 5,
                pathBackgroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
