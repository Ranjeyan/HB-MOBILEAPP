import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healingbee/screens/profile_screen.dart';
import 'package:healingbee/screens/quick_note_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../apphome/view.dart';
import 'assessments_screen.dart';

class AppEntryPage extends StatefulWidget {
  final User? user;

  const AppEntryPage({Key? key, required this.user}) : super(key: key);

  @override
  _AppEntryPageState createState() => _AppEntryPageState();
}

class _AppEntryPageState extends State<AppEntryPage> {
  int _selectedIndex = 0;
  late String userName = 'User';
  late String email;
  int _selectedEmotion = -1; // Initialize with -1, indicating no selection

  @override
  void initState() {
    super.initState();
    userName = 'User'; // Initialize with a default value
    email = widget.user?.email ?? '';

    // Fetch and set the user's name from Firestore
    fetchUserName(widget.user!.uid).then((name) {
      if (name != null) {
        setState(() {
          userName = name;
        });
      }
    });
  }

  void updateUserName(String newName) {
    setState(() {
      userName = newName;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<String?> fetchUserName(String userId) async {
    try {
      final userDoc =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return userDoc['name'];
      }
    } catch (e) {
      print("Error fetching user name: $e");
    }
    return null;
  }

  Future<bool> hasUserSubmittedToday() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final lastSubmissionDate = prefs.getString('lastSubmissionDate');

    // If the user has never submitted, or it's a different day, allow submission
    if (lastSubmissionDate == null || lastSubmissionDate != _getCurrentDate()) {
      return false;
    } else {
      return true; // User has already submitted today
    }
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    bool exitConfirmed = false;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData(
            dialogBackgroundColor: Colors.white,
          ),
          child: AlertDialog(
            title: const Text(
              'Exit App?',
              style: TextStyle(color: Colors.black, fontFamily: 'Helvetica'),
            ),
            content: const Text(
              'Do you want to exit the app?',
              style: TextStyle(color: Colors.black, fontFamily: 'Helvetica'),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel',
                    style: TextStyle(color: Colors.black, fontFamily: 'Helvetica')),
              ),
              TextButton(
                onPressed: () {
                  exitConfirmed = true;
                  Navigator.of(context).pop();
                },
                child: const Text('Exit',
                    style: TextStyle(color: Colors.black, fontFamily: 'Helvetica')),
              )
            ],
          ),
        );
      },
    );

    return exitConfirmed;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
          return false;
        } else {
          return await _showExitConfirmationDialog(context);
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            HomeView(
              userName: userName,
              selectedEmotion: _selectedEmotion,
              onAssessmentPressed: handleFeelingSubmission, // Pass the function here
            ),
            AssessmentsScreen(),
            const QuickNotes(),
            const AccountScreen()
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            height: 70,
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
                bottom: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildNavItem(0, Icons.home),
                buildNavItem(1, Icons.assessment),
                buildNavItem(2, Icons.note),
                buildNavItem(3, Icons.person),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNavItem(int index, IconData icon) {
    return IconButton(
      icon: Icon(
        icon,
        color: _selectedIndex == index ? Colors.white : Colors.white38,
        size: 30,
      ),
      onPressed: () {
        _onItemTapped(index);
      },
    );
  }

  // Function to handle feeling submission
  void handleFeelingSubmission() async {
    bool hasSubmittedToday = await hasUserSubmittedToday();
    if (!hasSubmittedToday) {
      // Allow the user to submit their feeling
      // ... your submission logic here ...

      // Update the last submission date in shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('lastSubmissionDate', _getCurrentDate());
    } else {
      // The user has already submitted today, show a message or take appropriate action
      // ... your action here ...
    }
  }
}

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MaterialApp(
    home: Scaffold(
      body: AppEntryPage(user: null),
    ),
  ));
}


