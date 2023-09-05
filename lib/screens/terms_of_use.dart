import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healingbee/main.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher package;
import 'package:healingbee/screens/Policy_Page.dart';

import 'home_page_content.dart';

class DetailsScreen extends StatefulWidget {
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showButton = false;
  bool _showScrollMessage = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.minScrollExtent) {
      setState(() {
        _showScrollMessage = true;
      });
    } else {
      setState(() {
        _showScrollMessage = false;
      });
    }

    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        _showButton = true;
      });
    } else {
      setState(() {
        _showButton = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD5F3E3),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 48),
            Center(
              child: Column(
                children: [
                  Text(
                    "PRIVACY POLICY",
                    style: TextStyle(
                      fontFamily: 'Neue Plak',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C6144),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Effective Date: 28th June 2023",
                    style: TextStyle(
                      fontFamily: 'Neue Plak',
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Visibility(
                        visible: _showScrollMessage,
                        child: Container(
                          margin: EdgeInsets.only(top:15 ),
                          padding: EdgeInsets.all(8),
                          color: Color(0xFF37AC6C),
                          child: Text(
                            "Scroll up to read and accept the Privacy Policy",
                            style: TextStyle(
                              fontFamily: 'Neue Plak',
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "At Black Dot Innovations Pvt Ltd (\"Company\"), we are committed to protecting the privacy of our users...",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Information We Collect : When you participate in our survey, we may collect the following types of information:\n\n"
                          "1.1 Personal Information: We may collect personal information that you provide voluntarily, such as your name, email address, and any other information you choose to provide in the survey.\n\n"
                          "1.2 Survey Responses: We collect the responses you provide to the GAD-7 and PHQ-9 questions as well as any additional questions in the survey.\n\n"
                          "1.3 Audio Recordings: With your consent, we may collect audio recordings associated with your survey responses.\n\n"
                          "Use of Information : We use the collected information for the following purposes:\n\n"
                          "2.1 Research and Development: The information collected is used for research and development purposes to improve our machine learning engine's ability to predict GAD-7 and PHQ-9 scores from voice samples.\n\n"
                          "2.2 Data Analysis: We analyze the collected data to gain insights into mental health assessment and support, helping us contribute to advancements in the field.\n\n"
                          "Third-Party Service Provider : We use the Aidaform form creator platform as a third-party service provider to collect the survey responses and audio recordings. As such, your personal information may be subject to Aidaform's privacy policy. We encourage you to review Aidaform's privacy policy at ",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        launch("https://aidaform.com/privacy-policy.html");
                      },
                      child: Text(
                        "https://aidaform.com/privacy-policy.html",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    Text(
                      " to understand how they handle your personal information.\n\n"
                          "Data Retention and Security :  We retain the collected information for as long as necessary to fulfill the purposes outlined...",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        launch("mailto:hello@blackdotinnovation.com");
                      },
                      child: Text(
                        "hello@blackdotinnovation.com",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    Text(
                      "\n\nChanges to the Privacy Policy :  We reserve the right to modify or update this Privacy Policy at any time...",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        launch("mailto:hello@blackdotinnovation.com");
                      },
                      child: Text(
                        "hello@blackdotinnovation.com",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    Text(
                      "\n\nBy participating in our survey, you acknowledge that you have read and understood this Privacy Policy...",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),

                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Visibility(
              visible: _showButton,
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage(initialLanguage: '',)),
                    );
                    // Handle button press
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF2C6144),
                  ),
                  child: Text(
                    "Accept & Continue",
                    style: TextStyle(
                      fontFamily: 'Neue Plak',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



void main() => runApp(MaterialApp(home: DetailsScreen()));
