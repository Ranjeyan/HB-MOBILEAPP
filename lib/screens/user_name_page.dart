import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'App_home_page.dart';

class NextPage extends StatefulWidget {
  final String userName;
  final String email;

  NextPage({required this.userName, required this.email});

  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set the initial value from the constructor
    _textEditingController.text = widget.userName;
  }

  @override
  void dispose() {
    // Dispose of the TextEditingController
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.w200,
                      color: Color(0XFF024022),
                      fontFamily: "lufga",
                    ),
                    children: [
                      TextSpan(
                        text: 'Hello there ',
                      ),
                      TextSpan(
                        text: ' 😀',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.0),
                Text(
                  'How should we identify you?',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w200,
                    color: Colors.black54,
                    fontFamily: "YukitaSans",
                  ),
                ),
                SizedBox(height: 36.0),
                TextField(
                  controller: _textEditingController,
                  style: TextStyle(
                    fontFamily: 'lufga',
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Your nickname or pseudonym?',
                    hintStyle: TextStyle(color: Color(0XFF024022)),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0XFF024022),
                      ),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () async {
                        String userName = _textEditingController.text.trim();
                        if (userName.isEmpty) {
                          showErrorMessage(context);
                        } else {
                          // Check if it's the first time the user sets the username
                          if (widget.userName.isEmpty) {
                            // First-time user, navigate to AppEntryPage and save the username
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.setString('userName', userName);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AppEntryPage(userName: widget.userName, email: widget.email),
                              ),
                            );
                          } else {
                            // Returning user, navigate to AppEntryPage and save the username
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.setString('userName', userName);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AppEntryPage(userName: widget.userName, email: widget.email),
                              ),
                            );
                          }
                        }
                      },
                      child: Icon(
                        Icons.arrow_forward,
                        color: Color(0XFF024022),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 36.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      String userName = _textEditingController.text.trim();
                      if (userName.isEmpty) {
                        showErrorMessage(context);
                      } else {
                        // Check if it's the first time the user sets the username
                        if (widget.userName.isEmpty) {
                          // First-time user, navigate to AppEntryPage and save the username
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          await prefs.setString('userName', userName);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AppEntryPage(userName: widget.userName, email: widget.email),
                            ),
                          );
                        } else {
                          // Returning user, navigate to AppEntryPage and save the username
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          await prefs.setString('userName', userName);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AppEntryPage(userName: widget.userName, email: widget.email),
                            ),
                          );
                        }
                      }
                    },
                    child: Text('Done', style: TextStyle(fontFamily: "lufga")),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      backgroundColor: Color(0XFF024022),
                      minimumSize: Size(150.0, 60.0),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showErrorMessage(BuildContext context) {
    final snackBar = SnackBar(
      content: Text(
        'Please enter your name.',
        style: TextStyle(fontFamily: "lufga"),
      ),
      backgroundColor: Color(0XFF024022),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
