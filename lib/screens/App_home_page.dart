import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healingbee/screens/assessments_screen.dart';
import 'package:healingbee/screens/profile_screen.dart';
import 'package:healingbee/screens/quick_note_screen.dart';

class AppEntryPage extends StatefulWidget {
  final User? user;

  AppEntryPage({Key? key, required this.user}) : super(key: key);

  @override
  _AppEntryPageState createState() => _AppEntryPageState();
}

class _AppEntryPageState extends State<AppEntryPage> {
  int _selectedIndex = 0;
  late String userName = 'User';
  late String email;

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

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    bool exitConfirmed = false;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Exit App?'),
          content: Text('Do you want to exit the app?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // User canceled exit
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // User confirmed exit
                exitConfirmed = true;
                Navigator.of(context).pop();
              },
              child: Text('Exit'),
            ),
          ],
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
        backgroundColor: Color(0XFF00463C),
        body: Stack(
          children: [
            IndexedStack(
              index: _selectedIndex,
              children: [
                Builder(
                  builder: (context) {
                    if (_selectedIndex == 0) {
                      // Custom AppBar for Home screen
                      return Column(
                        children: [
                          SizedBox(height: 20), // Add spacing below the status bar
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: AppBar(
                              backgroundColor: Color(0XFF00463C), // Replace with your desired color
                              title: Text(
                                'Welcome back, $userName!',
                                style: const TextStyle(fontSize: 28.0, color: Color(0XFFD4AF37)),
                              ),
                              actions: [
                                IconButton(
                                  icon: Icon(Icons.notifications),
                                  onPressed: () {
                                    // Handle notification button click
                                  },
                                ),
                              ],
                              elevation: 0,
                            ),
                          ),
                        ],
                      );
                    } else {
                      // Default AppBar for other screens
                      return AppBar(
                        elevation: 0,
                        backgroundColor: Color(0XFF00463C), // Customize as needed
                        title: Text(
                          'Screen Title', // Customize as needed
                          style: TextStyle(fontSize: 16.0, color: Color(0XFFD4AF37)),
                        ),
                      );
                    }
                  },
                ),
                AssessmentsScreen(), // Assessments page
                QuickNotesScreen(), // Quick Notes page
                ProfileScreen(), // Profile page
              ],
            ),
          ],
        ),
        bottomNavigationBar: BottomNavyBar(
          backgroundColor: Color(0XFF00463C),
          selectedIndex: _selectedIndex,
          onItemSelected: _onItemTapped,
          items: [
            BottomNavyBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Image.asset(
                  'assets/icons/home.png',
                  width: 24,
                  height: 24,
                ),
              ),
              title: const Padding(
                padding: EdgeInsets.only(top: 1),
                child: Text(
                  'Home',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              activeColor: Color(0XFFD4AF37),
            ),
            BottomNavyBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 3),
                child: Image.asset(
                  'assets/icons/assesment.png',
                  width: 24,
                  height: 24,
                ),
              ),
              title: const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'Assessment',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              activeColor: const Color(0XFFD4AF37),
            ),
            BottomNavyBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 2),
                child: Image.asset(
                  'assets/icons/quick_note.png',
                  width: 24,
                  height: 24,
                ),
              ),
              title: Padding(
                padding: EdgeInsets.only(bottom: 1),
                child: Text(
                  'Quick Note',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              activeColor: Color(0XFFD4AF37),
            ),
            BottomNavyBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 1),
                child: Image.asset(
                  'assets/icons/profile.png',
                  width: 24,
                  height: 24,
                ),
              ),
              title: Padding(
                padding: EdgeInsets.only(bottom: 1),
                child: Text(
                  'Profile',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              activeColor: Color(0XFFD4AF37),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final String iconPath;
  final String title;
  final String description;

  FeatureItem({
    required this.iconPath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            iconPath,
            width: 32,
            height: 32,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class QuoteSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Implement the daily quote section here
    return Container(
      // Add your daily quote content here
    );
  }
}

class CommunityHighlights extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Implement the community highlights section here
    return Container(
      // Add your community highlights content here
    );
  }
}

class TipsForMentalWellness extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Implement the tips for mental wellness section here
    return Container(
      // Add your tips for mental wellness content here
    );
  }
}

class FAQs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Implement the FAQs section here
    return Container(
      // Add your FAQs content here
    );
  }
}
