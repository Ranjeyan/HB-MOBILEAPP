import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

import 'Assesment/Assesment_detail.dart';

// Initialize the flutterLocalNotificationsPlugin
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Define notification initialization settings
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  // Initialize flutterLocalNotificationsPlugin with initialization settings
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );

  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;


  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

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
      home: SplashScreen(user: user, args: const {}),
      routes: {
        '/assessment-detail': (context) => AssessmentDetailPage(),
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
        final userName = widget.user?.displayName ?? 'DefaultUsername';
        final email = widget.user?.email ?? '';

        if (email.isEmpty) {
          navigateToDetailScreen();
        } else {
          Navigator.pushReplacementNamed(context, '/appEntry');
        }
      } else {
        navigateToDetailScreen();
      }
    });
  }

  Future<void> onSelectNotification(String? payload) async {
    // Handle the notification when the user taps on it.
    // You can add your custom logic here.
  }

  void navigateToDetailScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isNewUser = prefs.getBool('isNewUser') ?? true;

    if (isNewUser) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DetailScreen(userName: '', email: ''),
        ),
      );
    } else {
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
              flex: 10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo1.png',
                    height: 200.0,
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Your Text Here',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Transform.scale(
                scale: 0.5,
                child: const LoadingIndicator(
                  indicatorType: Indicator.ballScaleMultiple,
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
