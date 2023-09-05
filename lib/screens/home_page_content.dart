import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:healingbee/screens/terms_of_use.dart';
import 'package:flutter_locales/flutter_locales.dart';

import 'Policy_Page.dart';
import 'faq.dart';
import 'language_page.dart';

class HomePage extends StatefulWidget {
  final String initialLanguage;

  HomePage({required this.initialLanguage});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedLanguage = "Select Language";
  bool _termsAccepted = false;
  bool _faqAccepted = false;

  Future<void> _navigateToLanguagePage() async {
    final selectedLanguageName = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => LanguagePage()),
    );

    if (selectedLanguageName != null) {
      setState(() {
        _selectedLanguage = selectedLanguageName;
      });
    }
  }

  Future<void> _navigateToFAQPage() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => FAQPage()), // Replace with your FAQ page
    );

    setState(() {
      _faqAccepted = true; // Mark FAQs as accepted after returning from the FAQ page
    });
  }

  void _navigateToNextPage() {
    if (_termsAccepted && _faqAccepted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => PolicyPage()), // Replace with your next page
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("Please accept the Terms of Use and FAQs."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD5F3E3),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 60),
          Padding(
            padding: EdgeInsets.only(left: 25),
            child: LocaleText(
              "keep_a_diary",
              style: TextStyle(
                color: Color(0xFF2C6144),
                fontSize: 28,
                fontFamily: 'Ubuntu-M',
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.all(8),
                child: LocaleText(
                  "heading_1",
                  style: TextStyle(
                    fontFamily: 'Neue Plak',
                    fontSize: 23,
                    color: Color(0xFF37AC6C),
                  ),
                  maxLines: 10,
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.all(10),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'Neue Plak',
                      fontSize: 22,
                      color: Color(0xFF37AC6C),
                    ),
                    children: [
                      TextSpan(
                        text: "By using this application, you agree to its ",
                      ),
                      TextSpan(
                        text: "terms of use.",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Color(0xFF37AC6C)),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => DetailsScreen()),
                            );
                          },
                      ),
                    ],
                  ),
                  maxLines: 3,
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.all(10),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'Neue Plak',
                      fontSize: 22,
                      color: Color(0xFF37AC6C),
                    ),
                    children: [
                      TextSpan(
                        text: "Read our ",
                      ),
                      TextSpan(
                        text: "FAQs",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Color(0xFF37AC6C)),
                        recognizer: TapGestureRecognizer()
                          ..onTap = _navigateToFAQPage,
                      ),
                    ],
                  ),
                  maxLines: 3,
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ),
          SizedBox(height:150),
          Align(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: ElevatedButton(
                onPressed: _navigateToNextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF37AC6C), // Change the color here
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: LocaleText("continue",
                  style: TextStyle(
                      fontFamily:"Ubuntu"
                  ),),
              ),
            ),
          ),
          Spacer(),
          Align(
            alignment: Alignment.bottomLeft,
            child: InkWell(
              onTap: _navigateToLanguagePage,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Icon(Icons.language, size: 20),
                    SizedBox(width: 4),
                    Text(
                      _selectedLanguage.isNotEmpty
                          ? _selectedLanguage
                          : 'Select Language',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Ubuntu",
                        fontSize: 20,
                        color: Color(0xFF2C6144),
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_drop_down, size: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

