import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healingbee/Assesment/scorebar.dart';

import '../screens/assessments_screen.dart';

class ResultsScreen extends StatelessWidget {
  final int gad7Score;
  final int phq9Score;

  ResultsScreen(this.gad7Score, this.phq9Score);

  String getPhq9Result() {
    if (phq9Score >= 0 && phq9Score <= 10) {
      return "You are Good";
    } else if (phq9Score >= 11 && phq9Score <= 20) {
      return "Your PHQ-ASD score falls between 11 and 20 indicating a probable diagnosis of an anxiety or related disorder";
    } else if (phq9Score >= 21 && phq9Score <= 27) {
      return "Your PHQ-ASD score falls between 21 and 27 indicating a severe diagnosis of an anxiety or related disorder";
    } else {
      return "Invalid PHQ-9 Score";
    }
  }

  Future<void> saveScoresToFirestore() async {
    final firestore = FirebaseFirestore.instance;

    try {
      await firestore.collection('scores').add({
        'phq9Score': phq9Score,
        'gad7Score': gad7Score,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('Scores saved to Firestore successfully.');
    } catch (e) {
      print('Error saving scores to Firestore: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    String phq9Result = getPhq9Result();

    Color resultColor;
    if (phq9Result == "You are Good") {
      resultColor = Colors.green;
    } else if (phq9Result == "Your PHQ-ASD score falls between 11 and 20 indicating a probable diagnosis of an anxiety or related disorder") {
      resultColor = Colors.orange;
    } else if (phq9Result == "Your PHQ-ASD score falls between 21 and 27 indicating a severe diagnosis of an anxiety or related disorder") {
      resultColor = Colors.red;
    } else {
      resultColor = Colors.black;
    }

    String additionalMessage = '';
    if (phq9Score >= 21) {
      additionalMessage = '''
These symptoms are clinically significant and time is of the essence. Urgent evaluation is crucial, including a diagnostic interview and mental status examination.
We strongly urge you to seek immediate referral to a mental health professional for the support you need. Your well-being is paramount.
''';
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
          onPressed: () {
            saveScoresToFirestore();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AssessmentsScreen()),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 70.0),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 70.0),
                    child: ScoreBar(phq9Score),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text('GAD-7 Score: $gad7Score', style: const TextStyle(fontFamily: 'Lora', fontSize: 20)),
              Text('PHQ-9 Score: $phq9Score', style: const TextStyle(fontFamily: 'Lora', fontSize: 20)),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  ' $phq9Result',
                  style: TextStyle(fontFamily: 'Lora', fontSize: 20, color: resultColor),
                  textAlign: TextAlign.justify,
                ),
              ),
              if (additionalMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    additionalMessage,
                    style: const TextStyle(fontFamily: 'Lora', fontSize: 16, color: Colors.black),
                    textAlign: TextAlign.justify,
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 70.0, // Increase the height of the button
          child: ElevatedButton(
            onPressed: () {
              saveScoresToFirestore();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/assessment-detail',
                    (route) => false,
              );
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            child: const Text('Continue', style: TextStyle(fontFamily: 'Lora')),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ResultsScreen(15, 10),
  ));
}
