import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String _selectedLanguage = ""; // Initialize with an empty string

  void _changeLanguage(String languageCode, String languageName) {
    setState(() {
      _selectedLanguage = languageName; // Update selected language
    });

    final localeNotifier = LocaleNotifier.of(context);
    if (localeNotifier != null) {
      localeNotifier.change(languageCode);
    }
    Navigator.pop(context, languageName); // Pass back the selected language name
  }

  Widget _buildLanguageTile(String languageCode, String languageName) {
    final isSelected = _selectedLanguage == languageName;
    return ListTile(
      title: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              languageName,
              style: TextStyle(
                color: isSelected ? Colors.green : Colors.black,
              ),
            ),
            if (isSelected) Icon(Icons.check, color: Colors.green), // Add checkmark if selected
          ],
        ),
      ),
      onTap: () {
        _changeLanguage(languageCode, languageName); // Call _changeLanguage function
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF37AC6C),
        centerTitle: true,
        title: const LocaleText(
          "language",
          style: TextStyle(fontFamily: 'Neue Plak'),
        ),
      ),
      body: Column(
        children: [
          _buildLanguageTile('en', 'English'),
          _buildLanguageTile('gu', 'ગુજરાતી'),
          _buildLanguageTile('hi', 'हिंदी'),
          _buildLanguageTile('kn', 'ಕನ್ನಡ'),
          _buildLanguageTile('ml', 'മലയാളം'),
          _buildLanguageTile('mr', 'मराठी'),
          _buildLanguageTile('pa', 'ਪੰਜਾਬੀ'),
          _buildLanguageTile('ta', 'தமிழ்'),
          _buildLanguageTile('te', 'తెలుగు'),
          _buildLanguageTile('ur', 'اردو'),
        ],
      ),
    );
  }
}
