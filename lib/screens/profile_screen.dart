import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container( // Wrap in a Container
        padding: EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0), // Add padding
    child: ListView(
    children: [
          // Profile Picture and Edit Button
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  // Implement image selection logic here
                  // You can use a package like image_picker to select an image
                  // Update the profile picture
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    'https://unsplash.com/photos/OBufvGMaBaQ',
                    // Use your profile image URL here or AssetImage for a default image
                  ),
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Name',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Your Description',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(height: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        // Implement edit profile logic here
                        // You can navigate to an edit profile page or show a dialog for editing
                      },
                      child: Text('Edit Profile'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(),
          // Options
          ListTile(
            title: Text('Theme'),
            subtitle: Text('Light'),
            onTap: () {
              // Implement theme change logic here
            },
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            title: Text('App Language'),
            subtitle: Text('English'),
            onTap: () {
              // Implement app language change logic here
            },
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            title: Text('Privacy Policy'),
            onTap: () {
              // Implement privacy policy navigation here
            },
            trailing: Icon(Icons.chevron_right),
          ),
          Divider(),
          // Logout Button
          ListTile(
            title: Text('Logout'),
            onTap: () {
              // Implement logout logic here
              // You can navigate to the login page or show a confirmation dialog
            },
            trailing: Icon(Icons.exit_to_app),
          ),
        ],
      ),
        ),
    );
  }
}
