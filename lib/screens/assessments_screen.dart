import 'package:flutter/material.dart';

void main() {
  runApp(MentalWellnessApp());
}

class MentalWellnessApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AssessmentsScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AssessmentsScreen extends StatefulWidget {
  @override
  _AssessmentsScreenState createState() => _AssessmentsScreenState();
}

class _AssessmentsScreenState extends State<AssessmentsScreen> {
  double gadScore = 0; // Initialize the GAD score
  double phqScore = 0; // Initialize the PHQ score

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF00463C),
      appBar: AppBar(
        backgroundColor: Color(0XFF00463C),
        elevation: 0,
        title: Text('Assessment'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              // Navigate to GAD assessment questions page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GADAssessmentPage(
                    onScoreChanged: (score) {
                      setState(() {
                        gadScore = score;
                      });
                    },
                  ),
                ),
              );
            },
            child: Text('Take GAD Assessment'),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to PHQ assessment questions page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PHQAssessmentPage(
                    onScoreChanged: (score) {
                      setState(() {
                        phqScore = score;
                      });
                    },
                  ),
                ),
              );
            },
            child: Text('Take PHQ Assessment'),
          ),
          Text('GAD Score: $gadScore'),
          Text('PHQ Score: $phqScore'),
          // Add explanations and personalized recommendations here
        ],
      ),
    );
  }
}

class GADAssessmentPage extends StatelessWidget {
  final Function(double) onScoreChanged;

  GADAssessmentPage({required this.onScoreChanged});

  @override
  Widget build(BuildContext context) {
    // Implement GAD assessment questions and score calculation logic here
    // Example: a set of questions with a Likert scale for each question

    // Calculate the GAD score based on user's answers
    double gadScore = calculateGADScore();

    // Notify the parent page about the GAD score directly using the callback
    onScoreChanged(gadScore);

    return Scaffold(
      appBar: AppBar(
        title: Text('GAD Assessment'),
      ),
      // Add assessment questions and answer choices here
    );
  }

  double calculateGADScore() {
    // Implement GAD score calculation logic here
    // Example: Calculate the total score based on user's answers
    return 15.0; // Placeholder value; replace with actual calculation
  }
}

class PHQAssessmentPage extends StatelessWidget {
  final Function(double) onScoreChanged;

  PHQAssessmentPage({required this.onScoreChanged});

  @override
  Widget build(BuildContext context) {
    // Implement PHQ assessment questions and score calculation logic here
    // Example: a set of questions with a Likert scale for each question

    // Calculate the PHQ score based on user's answers
    double phqScore = calculatePHQScore();

    // Notify the parent page about the PHQ score
    onScoreChanged(phqScore);

    return Scaffold(
      appBar: AppBar(
        title: Text('PHQ Assessment'),
      ),
      // Add assessment questions and answer choices here
    );
  }

  double calculatePHQScore() {
    // Implement PHQ score calculation logic here
    // Example: Calculate the total score based on user's answers
    return 10.0; // Placeholder value; replace with actual calculation
  }
}
