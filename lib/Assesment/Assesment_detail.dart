import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healingbee/Assesment/phq_gad7.dart';

class AssessmentDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black, // Set the back button color
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0), // Add some space at the top
        child: Column(
          children: <Widget>[
            Image.asset(
              'assets/images/assesment.png',
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 50),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  '60% of us may say we\'re cool, but deep down, things may not be so groovy!',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Helvetica',
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Mindful music & meditation helps ease stress, yet optimal mental wellness demands real-time insights, personalized care, and priority management. This is a real-time mental wellness assessment tool. This data will be used for research purposes.',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                    fontFamily: 'Helvetica',
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            const SizedBox(height: 300.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _showAcceptanceBottomSheet(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black54,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13.0),
                  ),
                  minimumSize: Size(450, 60), // Adjust the size here
                ),
                child: const Text(
                  'Start Assessment',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Helvetica',
                    color: Colors.white60,
                  ), // Adjust the font size
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showAcceptanceBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.black,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'I consent to being audio recorded as part of this research study. By clicking "I Consent", I agree to take part in this research. I understand that if I do not consent to being audio recorded, I cannot participate in this study. I understand that you may disclose my personal information to a third party solely for the purposes of conducting this study',
                style: TextStyle(fontSize: 16.0, color: Colors.white70),
              ),
              const SizedBox(height: 10),
              const Text(
                'I have read and agreed to Terms and Conditions',
                style: TextStyle(fontSize: 16.0, color: Colors.white70),
              ),
              const SizedBox(height: 10),
              const Text(
                'I have read the FAQs',
                style: TextStyle(fontSize: 16.0, color: Colors.white70),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AssessmentDetails()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade500,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    child: const Text('Accept', style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please accept to take the assessment.',
                            style: TextStyle(fontFamily: 'Helvetica'),
                          ),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    child: const Text('Deny', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AssessmentDetailPage(),
  ));
}
