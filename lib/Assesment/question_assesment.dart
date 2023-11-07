import 'package:flutter/material.dart';
import 'package:healingbee/Assesment/results_screen.dart';

void main() {
  runApp(MaterialApp(
    home: QuestionAssessment(),
  ));
}

class QuestionAssessment extends StatefulWidget {
  @override
  _QuestionAssessmentState createState() => _QuestionAssessmentState();
}

class _QuestionAssessmentState extends State<QuestionAssessment> {
  List<Question> questions = [
    Question(
      "Feeling nervous, anxious or on edge?",
      ["Not at all", "Several days", "More than half the days", "Nearly every day"],
    ),
    Question(
      "Unable to control worrying?",
      ["Not at all", "Several days", "More than half the days", "Nearly every day"],
    ),
    Question(
      "Excessive worrying about various things?",
      ["Not at all", "Several days", "More than half the days", "Nearly every day"],
    ),
    Question(
      "Difficulty relaxing?",
      ["Not at all", "Several days", "More than half the days", "Nearly every day"],
    ),
    Question(
      "Restlessness, unable to sit still?",
      ["Not at all", "Several days", "More than half the days", "Nearly every day"],
    ),
    Question(
      "Easily irritated or annoyed?",
      ["Not at all", "Several days", "More than half the days", "Nearly every day"],
    ),
    Question(
      "Fearful, expecting something terrible?",
      ["Not at all", "Several days", "More than half the days", "Nearly every day"],
    ),
    Question(
      "Lack of interest or joy in activities?",
      ["Not at all", "Several days", "More than half the days", "Nearly every day"],
    ),
    Question(
      "Feeling down or hopeless?",
      ["Not at all", "Several days", "More than half the days", "Nearly every day"],
    ),
    Question(
      "Sleep troubles or changes?",
      ["Not at all", "Several days", "More than half the days", "Nearly every day"],
    ),
    Question(
      "Fatigue or low energy?",
      ["Not at all", "Several days", "More than half the days", "Nearly every day"],
    ),
    Question(
      "Appetite changes?",
      ["Not at all", "Several days", "More than half the days", "Nearly every day"],
    ),
    Question(
      "Negative self-perception or disappointment?",
      ["Not at all", "Several days", "More than half the days", "Nearly every day"],
    ),
    Question(
      "Difficulty focusing or concentrating?",
      ["Not at all", "Several days", "More than half the days", "Nearly every day"],
    ),
    Question(
      "Slow movements or speech, or restlessness?",
      ["Not at all", "Several days", "More than half the days", "Nearly every day"],
    ),
    Question(
      "Thoughts of self-harm or feeling better off dead",
      ["Not at all", "Several days", "More than half the days", "Nearly every day"],
    ),
  ];

  int currentQuestionIndex = 0;
  int selectedOption = -1;

  // Variables to store the scores
  int gad7Score = 0;
  int phq9Score = 0;

  void selectOption(int optionIndex) {
    setState(() {
      selectedOption = optionIndex;

      // Calculate scores based on the selected options
      if (currentQuestionIndex < 7) {
        // Calculate GAD-7 score (options 0, 1, 2, 3 correspond to 0, 1, 2, 3 points)
        gad7Score += optionIndex;
      } else if (currentQuestionIndex >= 7 && currentQuestionIndex < 16) {
        // Calculate PHQ-9 score (options 0, 1, 2, 3 correspond to 0, 1, 2, 3 points)
        phq9Score += optionIndex;
      }
    });

    Future.delayed(Duration(seconds: 2), () {
      moveToNextQuestion();
    });
  }

  void moveToNextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedOption = -1;
      });
    } else {
      // If all questions are answered, navigate to the results screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsScreen(gad7Score, phq9Score),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 90), // Add some space at the top
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Over the last two weeks, how often have you been bothered by any of the following problems?", // Add your topic here
                style: TextStyle(
                  fontSize: 20, // Adjust the font size
                  fontWeight: FontWeight.bold,
                  color: Colors.black26, // Change the color
                  fontFamily: 'Lora',
                ),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                questions[currentQuestionIndex].questionText,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,fontFamily: 'Helvetica'),
              ),
            ),
            SizedBox(height: 20,),
            Center(
              child: Column(
                children: questions[currentQuestionIndex].options
                    .asMap()
                    .entries
                    .map((entry) {
                  final optionIndex = entry.key;
                  final optionText = entry.value;
                  final isSelected = optionIndex == selectedOption;
                  return InkWell(
                    onTap: () {
                      selectOption(optionIndex);
                    },
                    child: Container(
                      width: 450, // Set a fixed width for the choice boxes
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? Colors.black26 : Colors.black12,
                        ),
                        color: isSelected ? Colors.black26 : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        optionText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontFamily: 'Helvetica',
                        ),
                      ),
                    ),
                  );
                })
                    .toList(),
              ),
            )

          ],
        ),
      ),
    );
  }
}

class Question {
  final String questionText;
  final List<String> options;

  Question(this.questionText, this.options);
}
