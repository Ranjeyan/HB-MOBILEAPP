import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healingbee/screens/assessments_screen.dart';
import 'package:healingbee/screens/profile_screen.dart';
import 'package:healingbee/screens/quick_note_screen.dart';

class AppEntryPage extends StatefulWidget {
  final String userName;

  AppEntryPage({required this.userName, required user});

  @override
  _AppEntryPageState createState() => _AppEntryPageState();
}

class _AppEntryPageState extends State<AppEntryPage> {
  int _selectedIndex = 0;

  // Define the pages that correspond to each navigation item.
  List<Widget> _pages = [
    AssessmentsScreen(),
    QuickNotesScreen(),
    ProfileScreen(), // Replace with your profile page widget
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Use the Navigator to push the selected page.
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => _pages[index],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome back, ${widget.userName}!',
              style: TextStyle(fontSize: 18.0),
            ),
            // Add your widgets and content here
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Assessments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notes),
            label: 'Quick Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue, // Change to your desired color
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        elevation: 0.0, // Set elevation to 0.0 to remove shadow
      ),
    );
  }
}
