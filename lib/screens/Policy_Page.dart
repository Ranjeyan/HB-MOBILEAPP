import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'next.dart';


class PolicyPage extends StatefulWidget {
  const PolicyPage({Key? key}) : super(key: key);

  @override
  State<PolicyPage> createState() => _PolicyPageState();
}

class _PolicyPageState extends State<PolicyPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFBAFAD1),
      appBar: AppBar(
        backgroundColor: Color(0xFF37AC6C),
        title: Text('Policy Page'),
      ),
      body: Center(
        child: Text('Content of the Policy Page'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          if (index == 0) {
            // Navigating back to the existing home page when "Home" is tapped
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else if (index == 1) {
            // Navigating to the next page
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => NextPage()));
          }
        },
        items: [
          BottomNavigationBarItem(
            backgroundColor:Color(0xFFBAFAD1) ,
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.navigate_next),
            backgroundColor: Color(0xFFBAFAD1),
            label: 'Next Page',
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PolicyPage(),
  ));
}
