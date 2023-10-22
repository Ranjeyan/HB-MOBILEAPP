import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healingbee/screens/assessments_screen.dart';
import 'package:healingbee/screens/profile_screen.dart';
import 'package:healingbee/screens/quick_note_screen.dart';

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
        return Theme(
          data: ThemeData(
            dialogBackgroundColor: Colors.white,
          ),
          child: AlertDialog(
            title: const Text(
              'Exit App?',
              style: TextStyle(color: Colors.black,fontFamily: 'Helvetica'),
            ),
            content: const Text(
              'Do you want to exit the app?',
              style: TextStyle(color: Colors.black,fontFamily: 'Helvetica'),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel', style: TextStyle(color:  Colors.black,fontFamily: 'Helvetica'),
                ),
              ),
              TextButton(
                onPressed: () {
                  exitConfirmed = true;
                  Navigator.of(context).pop();
                },
                child: const Text('Exit', style: TextStyle(color:  Colors.black,fontFamily: 'Helvetica'),
                ),
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
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            IndexedStack(
              index: _selectedIndex,
              children: [
                Builder(
                  builder: (context) {
                    if (_selectedIndex == 0) {
                      return Column(
                        children: [
                          const SizedBox(height: 2),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: AppBar(
                              backgroundColor: Colors.white,
                              toolbarHeight: 80.0,
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(top: 1.0),
                                    child: Text(
                                      'hello,',
                                      style: TextStyle(
                                          fontSize: 24.0, color: Colors.black54,
                                          fontFamily: 'Helvetica'),
                                    ),
                                  ),
                                  const SizedBox(height: 5,),
                                  Text(
                                    userName,
                                    style: const TextStyle(
                                        fontSize: 28.0, color: Colors.black54,
                                        fontFamily: 'Helvetica'),
                                  ),
                                ],
                              ),
                              actions: [
                                IconButton(
                                  icon: const Icon(Icons.notifications, color: Colors.black54),
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
                      return AppBar(
                        elevation: 0,
                        backgroundColor: Colors.white,
                        title: const Text(
                          'Screen Title',
                          style: TextStyle(fontSize: 16.0, color: Color(0XFFD4AF37)),
                        ),
                      );
                    }
                  },
                ),
                AssessmentsScreen(),
                const HomeView(),
                const AccountScreen(),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 15,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
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
          ],
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
}

void main() {
  runApp(const MaterialApp(
    home: Scaffold(
      body: AppEntryPage(user: null),
    ),
  ));
}
