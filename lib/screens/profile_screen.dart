import 'package:flutter/material.dart';
import 'package:healingbee/screens/edit_profile_screen.dart';
import 'package:healingbee/screens/privacy_policy.dart';
import 'package:healingbee/screens/sign_in_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isDarkThemeEnabled = false;
  String selectedLanguage = 'English';
  String userName = '';
  String userEmail = '';
  String userProfileImage = 'assets/images/img.png';

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
  }

  void _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? '';
      userEmail = prefs.getString('userEmail') ?? '';
      userProfileImage = prefs.getString('userProfileImage') ?? userProfileImage;
    });
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
          backgroundColor: Color(0xFF024022), // Custom background color
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
                        primary: Color(0XFF5D8374), // Custom button background color
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
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.clear();
                        Navigator.of(context).pop();

                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => HomePage(), // Replace with your sign-in screen.
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
                    color: Colors.black54,
                    fontFamily: 'Readexpro',
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 1,
                color: Color(0XFF024022),
                child: SingleChildScrollView(
                  child: Column(
                    children: languages.map((language) {
                      final translation = languageTranslations[language] ?? '';

                      return InkWell(
                        splashColor: Colors.blue,
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
                                          color: Color(0XFF89B5A0),
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(top: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Profile',
                      style: TextStyle(fontFamily: 'Poppins', color: Color(0XFF024022), fontSize: 35),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.home,
                        size: 35,
                        color: Color(0XFF024022),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(
                        userName: userName,
                        userDob: '',
                        userProfileImage: userProfileImage,
                        userEmail: 'johndoe@example.com',
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 20, top: 40),
                      child: ClipOval(
                        child: Image.asset(
                          userProfileImage,
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
                          margin: EdgeInsets.only(top: 40),
                          child: Text(
                            userName,
                            style: TextStyle(
                              fontSize: 24.0,
                              fontFamily: 'Yukitasans',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Text(
                            userEmail,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: 'ReadexPro',
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfileScreen(
                              userName: userName,
                              userDob: '', // Empty string as a placeholder
                              userProfileImage: userProfileImage,
                              userEmail: 'johndoe@example.com',// Pass the same profile image
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 35),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
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
              SizedBox(height: 50),
              ListTile(
                leading: Icon(Icons.brightness_6),
                title: Text('Dark Theme',style: TextStyle(fontFamily: 'Poppins'),),
                trailing: Switch(
                  value: isDarkThemeEnabled,
                  onChanged: (value) {
                    setState(() {
                      isDarkThemeEnabled = value;
                    });
                  },
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
              ),
              SizedBox(height: 25,),
              ListTile(
                leading: Icon(Icons.privacy_tip),
                title: Text('Privacy Policy',style: TextStyle(fontFamily: 'Poppins'),),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsScreen(),
                    ),
                  );
                },
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
              ),
              SizedBox(height: 25,),
              ListTile(
                leading: Icon(Icons.language),
                title: Text('App Language',style: TextStyle(fontFamily: 'Poppins'),),
                trailing: Text(
                  selectedLanguage,
                  style: TextStyle(
                    color: Color(0XFF024022),
                    fontFamily: 'Poppins',
                  ),
                ),
                onTap: () {
                  _showLanguageSelectionSheet();
                },
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
              ),
              SizedBox(height: 25),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Logout',style: TextStyle(fontFamily: 'Poppins'),),
                onTap: () {
                  _showLogoutConfirmationDialog();
                },
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
              ),
            ],
          ),
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