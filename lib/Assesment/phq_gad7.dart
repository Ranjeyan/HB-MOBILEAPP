import 'package:flutter/material.dart';
import 'package:healingbee/Assesment/voice_assesment.dart';

class AssessmentDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black54,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: const <TextSpan>[
                    TextSpan(
                      text: 'Depression and anxiety are the two most common mental health conditions in the general population as well as in clinical practice.',
                      style: TextStyle(fontSize: 20, height: 2.5, decoration: TextDecoration.none, color: Colors.black54, fontFamily: 'Lora'),
                    ),
                    TextSpan(
                      text: '\n\nDepression and anxiety also result in substantial disability, representing the 2nd and 5th leading causes of years lived with disability in the United States and accounting for enormous losses in work productivity as well as high direct and indirect health care costs.',
                      style: TextStyle(fontSize: 20, height: 2.5, decoration: TextDecoration.none, color: Colors.black54, fontFamily: 'Lora'),
                    ),
                    TextSpan(
                      text: '\n\nThe Patient Health Questionnaire 9-item depression scale (PHQ-9) and 7-item Generalized Anxiety Disorder scale (GAD-7) are among the best validated and most commonly used depression and anxiety measures, respectively.20-25',
                      style: TextStyle(fontSize: 20, height: 2.5, decoration: TextDecoration.none, color: Colors.black54, fontFamily: 'Lora'),
                    ),
                    TextSpan(
                      text: '\n\nThey have been used in hundreds of research studies, incorporated into numerous clinical practice guidelines, and adopted by a variety of medical and mental health care practice settings.',
                      style: TextStyle(fontSize: 20, height: 2.5, decoration: TextDecoration.none, color: Colors.black54, fontFamily: 'Lora'),
                    ),
                    TextSpan(
                      text: '\n\nImportantly, the PHQ-9 and GAD-7 are public domain measures available in more than 80 translations, many of which can be freely downloaded at www.phqscreeners.com.',
                      style: TextStyle(fontSize: 20, height: 2.5, decoration: TextDecoration.none, color: Colors.black54, fontFamily: 'Lora'),
                    ),
                    TextSpan(
                      text: '\n\nThis paper uses data from 3 clinical trials to examine the reliability and convergent, construct, and factor structure validity as well as sensitivity to change of the Patient Health Questionnaire Anxiety-Depression Scale (PHQ-ADS) – a 16-item scale comprising the PHQ-9 and GAD-7 – as a composite measure of depression and anxiety.',
                      style: TextStyle(fontSize: 20, height: 2.5, decoration: TextDecoration.none, color: Colors.black54, fontFamily: 'Lora'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              // Navigate to the next page when the "Proceed" button is tapped.
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VoiceAssessment(key:GlobalKey(), title: '',), // Replace with the actual next page widget
                ),
              );
            },
            child: Container(
              height: 50,
              color: Colors.black54,
              alignment: Alignment.center,
              child: const Text(
                'Proceed',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontFamily: 'Helvetica',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
