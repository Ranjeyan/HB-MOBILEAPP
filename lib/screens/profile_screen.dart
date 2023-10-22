import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healingbee/screens/privacy_policy.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/forward_button.dart';
import '../widgets/setting_item.dart';
import 'edit_screen.dart';
import 'hb_detaills.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String selectedLanguage = 'English';
  String userName = '';
  String userEmail = '';
  String userProfileImage = 'assets/icons/avatar.png';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (userSnapshot.exists) {
        setState(() {
          userName = userSnapshot.get('name') ?? '';
          userEmail = userSnapshot.get('email') ?? '';
        });

        final userProfileImageUrl = userSnapshot.get('profileImage');
        if (userProfileImageUrl != null && userProfileImageUrl.isNotEmpty) {
          userProfileImage = userProfileImageUrl;
        } else {
          userProfileImage = 'assets/icons/avatar.png';
        }

        prefs.setString('userProfileImage', userProfileImage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Ionicons.chevron_back_outline, color: Colors.black54),
        ),
        leadingWidth: 80,
      ),
      body: _buildAccountScreen(),
    );
  }

  Widget _buildAccountScreen() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double textFontSize = constraints.maxWidth < 600 ? 30 : 36;
            double titleFontSize = constraints.maxWidth < 600 ? 20 : 24;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Settings",
                  style: TextStyle(
                    fontSize: textFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Helvetica',
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  "Account",
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  children: [
                    ClipOval(
                      child: userProfileImage != null && Uri.parse(userProfileImage).isAbsolute
                          ? Image.network(
                        userProfileImage,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      )
                          : Image.asset(
                        'assets/icons/avatar.png',
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName ?? "User Name",
                            style: TextStyle(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontFamily: 'Helvetica',
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            userEmail ?? "user@example.com",
                            style: TextStyle(
                              fontSize: titleFontSize,
                              color: Colors.black54,
                              fontFamily: 'Helvetica',
                            ),
                          ),
                        ],
                      ),
                    ),
                    ForwardButton(
                      onTap: () async {
                        final updatedImage = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditAccountScreen(),
                          ),
                        );
                        if (updatedImage != null) {
                          setState(() {
                            userProfileImage = updatedImage; // Update the profile image
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Text(
                  "Settings",
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 20),
                SettingItem(
                  title: "Language",
                  icon: Ionicons.earth,
                  bgColor: Colors.black54,
                  iconColor: Colors.white,
                  value: "English",
                  onTap: () {},
                ),
                const SizedBox(height: 20),
                SettingItem(
                  title: "Notifications",
                  icon: Ionicons.notifications,
                  bgColor: Colors.black54,
                  iconColor: Colors.white,
                  onTap: () {},
                ),
                const SizedBox(height: 20),
                // Privacy Policy Option
                SettingItem(
                  title: "Privacy Policy",
                  icon: Ionicons.nuclear,
                  bgColor: Colors.black54,
                  iconColor: Colors.white,
                  onTap: () {
                    // Navigate to Privacy Policy screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DetailsScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                // Logout Option
                SettingItem(
                  title: "Logout",
                  icon: Ionicons.log_out,
                  bgColor:Colors.black54,
                  iconColor: Colors.white,
                  onTap: () {
                    _showLogoutConfirmationDialog();
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _showLogoutConfirmationDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Logout",style: TextStyle(fontFamily: 'Helvetica'),),
          // Customize the background color of the dialog
          backgroundColor: Colors.white, // Change this to your desired color

          // You can wrap the content in a Container to set the text color
          content: Container(
            // Customize the text color
            child: const Text("Are you sure you want to log out?", style: TextStyle(color: Colors.black,fontFamily: 'Helvetica')),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel",style: TextStyle(fontFamily: 'Helvetica',color: Colors.black),),
            ),
            TextButton(
              onPressed: () {
                _logoutUserAndNavigateToDetails();
              },
              child: const Text("OK",style: TextStyle(fontFamily: 'Helvetica',color: Colors.black),),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logoutUserAndNavigateToDetails() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pop(); // Close the AccountScreen
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => DetailScreen(userName: '', email: '',),
    ));
  }
}

void main() {
  runApp(MaterialApp(
    home: AccountScreen(),
  ));
}
