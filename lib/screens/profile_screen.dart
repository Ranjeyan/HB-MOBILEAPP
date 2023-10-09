import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:healingbee/screens/privacy_policy.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'edit_profile_screen.dart';
import 'notify.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String selectedLanguage = 'English';
  String userName = '';
  String userEmail = '';
  String userProfileImage = 'assets/images/profile.png';

  List<String> languages = [
    'English',
    'Tamil',
    'Hindi',
    'Telugu',
    'Malayalam',
    'Kannada',
    'Urdu',
    'Marathi',
    'Gujarati',
    'Punjabi',
    'Bengali',
  ];

  Map<String, String> languageTranslations = {
    'English': 'English',
    'Tamil': 'தமிழ்',
    'Hindi': 'हिन्दी',
    'Telugu': 'తెలుగు',
    'Malayalam': 'മലയാളം',
    'Kannada': 'ಕನ್ನಡ',
    'Urdu': 'اردو',
    'Marathi': 'मराठी',
    'Gujarati': 'ગુજરાતી',
    'Punjabi': 'ਪੰਜਾਬੀ',
    'Bengali': 'বাংলা',
  };

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Set your desired color here
    ));
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
          userProfileImage = 'assets/images/profile.png';
        }

        prefs.setString('userProfileImage', userProfileImage);
      }
    }
  }

  Future<void> _updateUserDataInFirestore(String name, String gender, String dob, String image) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'name': name,
          'gender': gender,
          'dob': dob,
          'profileImage': image,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile updated successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        print('Error updating user data: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _showLanguageSelectionSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                leading: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: Text(
                  'App Language',
                  style: TextStyle(
                    fontWeight: FontWeight.w200,
                    fontSize: 18.0,
                    color: Color(0XFFD4AF37),
                    fontFamily: 'Readexpro',
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 1,
                color: Color(0XFF00463C),
                child: SingleChildScrollView(
                  child: Column(
                    children: languages.map((language) {
                      final translation = languageTranslations[language] ?? '';

                      return InkWell(
                        splashColor: Color(0XFFD4AF37),
                        onTap: () {
                          setState(() {
                            selectedLanguage = language;
                          });
                          Navigator.pop(context);
                        },
                        child: Column(
                          children: [
                            ListTile(
                              title: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      language,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Colors.white,
                                      ),
                                    ),
                                    if (translation.isNotEmpty)
                                      Text(
                                        '($translation)',
                                        style: TextStyle(
                                          color: Color(0XFFF06151),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            if (language != languages.last) SizedBox(height: 10),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showLogoutConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Color(0XFFD4AF37), // Custom background color
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Logout Confirmation',
                  style: TextStyle(
                    color: Colors.white, // Custom text color
                    fontSize: 18.0,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Do you want to logout?',
                  style: TextStyle(
                    color: Colors.white, // Custom text color
                    fontSize: 16.0,
                    fontFamily: 'lufga',
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Center buttons horizontally
                  children: <Widget>[
                    TextButton(
                      child: Text(
                        'No',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white, // Custom text color
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0XFF00463C), // Custom button background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Text(
                        'Yes',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white, // Custom text color
                        ),
                      ),
                      onPressed: () async {
                        // Sign out the user from Firebase
                        try {
                          await FirebaseAuth.instance.signOut();
                        } catch (e) {
                          print('Error signing out: $e');
                        }

                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.clear();
                        Navigator.of(context).pop();

                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => SplashScreen(args: {
                              'userName': '',
                              'email': '',
                            }, user: null),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF00463C),
      body: Stack(
        children: [
          Positioned(
            top: -MediaQuery.of(context).size.height / 2.1,
            left: -(MediaQuery.of(context).size.width * 0.5),
            right: -(MediaQuery.of(context).size.width * 0.5),
            child: Container(
              height: MediaQuery.of(context).size.height / 1.4,
              width: MediaQuery.of(context).size.width * 1.9,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0XFFD4AF37),
              ),
            ),
          ),
          Positioned(
            top: 140,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  GestureDetector(
                    onTap: () {
                      // Handle profile picture tap here
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      width: 130,
                      height: 130,
                      child: ClipOval(
                        child: userProfileImage.startsWith('http') // Check if it's a network URL
                            ? Image.network(
                          userProfileImage, // Load network image
                          width: 130,
                          height: 130,
                          fit: BoxFit.cover,
                        )
                            : Image.asset(
                          userProfileImage, // Load asset image
                          width: 130,
                          height: 130,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Helvetica',
                      fontWeight: FontWeight.bold,
                      color: Color(0XFFD4AF37),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    userEmail,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'Helvetica',
                      color: Colors.grey,
                    ),
                  ),

                  SizedBox(height: 40),
                  ListTile(
                    leading: Icon(Icons.privacy_tip, color: Color(0XFFF06151)),
                    title: Text(
                      'Privacy Policy',
                      style: TextStyle(
                        fontFamily: 'Helvetica',
                        color: Color(0XFFD4AF37),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsScreen(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 25),
                  ListTile(
                    leading: Icon(Icons.language, color: Color(0XFFF06151)),
                    title: Text(
                      'App Language',
                      style: TextStyle(
                        fontFamily: 'Helvetica',
                        color: Color(0XFFD4AF37),
                      ),
                    ),
                    trailing: Text(
                      selectedLanguage,
                      style: TextStyle(
                        color: Color(0XFFF06151),
                        fontFamily: 'Helvetica',
                      ),
                    ),
                    onTap: () {
                      _showLanguageSelectionSheet();
                    },
                  ),
                  SizedBox(height: 25),
                  ListTile(
                    leading: Icon(Icons.notifications, color: Color(0XFFF06151)),
                    title: Text(
                      'Notifications',
                      style: TextStyle(
                        fontFamily: 'Helvetica',
                        color: Color(0XFFD4AF37),
                      ),
                    ),
                    onTap: () {
                      // Implement your Notifications logic here
                    },
                  ),
                  SizedBox(height: 25),
                  ListTile(
                    leading: Icon(Icons.exit_to_app, color: Color(0XFFF06151)),
                    title: Text(
                      'Logout',
                      style: TextStyle(
                        fontFamily: 'Helvetica',
                        color: Color(0XFFD4AF37),
                      ),
                    ),
                    onTap: () {
                      _showLogoutConfirmationDialog();
                    },
                  ),
                  SizedBox(height: 25),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    width: 160, // Expand the button to the full width
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfileScreen(
                              userName: userName,
                              userDob: '', // You should provide the user's date of birth here
                              userProfileImage: userProfileImage,
                              userEmail: userEmail,
                              userGender: '', // You should provide the user's gender here
                              onSave: (String name, String gender, String dob, String image) {
                                _updateUserDataInFirestore(name, gender, dob, image);
                                setState(() {
                                  userProfileImage = image; // Update the profile picture URL in this screen
                                });
                              },
                            ),
                          ),
                        ).then((value) {
                          _fetchUserData();
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color(0XFF00463C),
                          border: Border.all(
                            color: Color(0XFFD4AF37),
                            width: 2.0, // Increase the border width for better visibility
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontFamily: 'Helvetica',
                              color: Color(0XFFD4AF37),
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ProfileScreen(),
  ));
}
