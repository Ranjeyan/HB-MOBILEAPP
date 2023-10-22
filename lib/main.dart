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


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;

  await Locales.init(
      ['en', 'gu', 'hi', 'kn', 'ml', 'mr', 'pa', 'ta', 'te', 'ur']);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
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
      locale: const Locale('en'),
      // Set the "home" property to SplashScreen
      home: SplashScreen(user: user, args: const {}),
      routes: {
        '/appEntry': (context) {
          if (user != null) {
            return AppEntryPage(user: user);
          } else {
            return HomePage();
          }
        },

        '/profile': (context) => const AccountScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          final args = settings.arguments as Map<String, dynamic>?;
          if (args != null && args.containsKey('userName')) {
            final userName = args['userName'] as String;
            return MaterialPageRoute(
              builder: (context) => const AppEntryPage(
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

  const SplashScreen({Key? key, required this.user, required Map<String, String> args}) : super(key: key);

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
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 10, // Adjust the flex values as needed
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo1.png',
                    height: 200.0,
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Your Text Here', // Replace with your desired text
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1, // Adjust the flex values as needed
              child: Transform.scale(
                scale: 0.5,
                child: const LoadingIndicator(
                  indicatorType: Indicator. ballScaleMultiple,
                  colors: [Colors.black54],
                  strokeWidth: 5,
                  pathBackgroundColor: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
