import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healingbee/screens/assessments_screen.dart';
import 'package:healingbee/screens/profile_screen.dart';
import 'package:healingbee/screens/quick_note_screen.dart';

class AppEntryPage extends StatefulWidget {
  final String userName;
  final String email;

  AppEntryPage({required this.userName, required this.email});

  @override
  _AppEntryPageState createState() => _AppEntryPageState();
}


class _AppEntryPageState extends State<AppEntryPage> {
  int _selectedIndex = 0;

  // Define the pages that correspond to each navigation item.
  List<Widget> _pages = [
    AssessmentsScreen(),
    QuickNotesScreen(),
    ProfileScreen(),
  ];

  Future<bool> _onWillPop() async {
    SystemNavigator.pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
          onTap: (index) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => _pages[index],
              ),
            );
            setState(() {
              _selectedIndex = index;
            });
            // You can use Navigator or any other navigation method as needed
          },
          elevation: 0.0,
        ),
      ),
    );
  }
}
