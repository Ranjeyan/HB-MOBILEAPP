import 'package:flutter/material.dart';
import 'package:healingbee/screens/edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 45),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Profile',
                    style: TextStyle(fontFamily: 'lufga', color: Color(0XFF024022), fontSize: 35),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.home,
                      size: 35,
                      color: Color(0XFF024022), // Customize the icon color
                    ),
                    onPressed: () {
                      // Handle home button click here
                    },
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                // Navigate to the EditProfilePage when the image is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(),
                  ),
                );
              },
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 50, top: 40), // Adjust top margin to move down
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/img.png',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 40), // Adjust top margin to move down
                        child: Text(
                          'Name',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5), // Adjust top margin to move down
                        child: Text(
                          'ran@email.com',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacer(), // To push the arrow to the right
                  GestureDetector(
                    onTap: () {
                      // Handle navigation to edit profile
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 35),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent, // Transparent background
                      ),
                      child: Image.asset(
                        'assets/images/arrow.png',
                        width: 30,
                        height: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text('Theme'),
              onTap: () {
                // Handle theme change logic here
              },
            ),
            ListTile(
              title: Text('Privacy Policy'),
              onTap: () {
                // Handle privacy policy navigation here
              },
            ),
            ListTile(
              title: Text('App Language'),
              onTap: () {
                // Handle app language change logic here
              },
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                // Handle logout logic here
              },
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ProfileScreen(),
  ));
}
