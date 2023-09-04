import 'package:flutter/material.dart';

import 'Policy_Page.dart';

class FAQPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF37AC6C),
        centerTitle: true,
        title: Text("FAQ's"),
      ),
      body: FAQContent(),
    );
  }
}

class FAQContent extends StatelessWidget {
  final List<String> faqQuestions = [
    // Your list of FAQ questions goes here
    "1) You are being invited to take part in a research study. What should I know about this research?",
    "2) Taking part in this research is voluntary.",
    "3) There is no penalty if you do not join.",
    "4) You can always opt out.",
    "5) Feel free to ask questions anytime",
  "6) Ask any questions before making your decision.",
  "7)Why is this research being done?",
  "8) Depression affects 30% of people every year, and early detection can make a big difference."
  "9) Artificial intelligence can help doctors find depression early and get people to the right level of care.",
  "10) The purpose of this study is to find correlations between voice and how people sound with clinical diagnoses.",
  "11) 1,000 people will take part in this research.",
  "12) How long will I be in this research?",
  "13) The study will last 45 minutes or less.",
  "14) You will be asked to complete a web-based",
  "15) Voice recorded section:",
  "16) 3 questions that are up to 60 seconds each.",
  "17) 16 multiple-choice questions that ask a range of how you are feeling.",
  "18) A clinical assessment from a licensed mental health professional immediately following the survey above (30 min).",
  "19) What happens to me if I agree to take part in this research?",
  "20) You will be required to record your voice answering specific questions.",
  "21) The recordings will be analyzed for pitch, tone, and other traits.",
  "22) After the voice recordings, you will complete two self-assessments: PHQ-9 and GAD-7.",
  "23) Shortly thereafter, you will be asked to follow a link to start a video conference call with a mental health professional for further evaluation.",
  "24) Potential risks:",
  "25) There is always the potential for breach of confidentiality, but all entries are encrypted.",
  "26) Participation may bring up emotional content that could temporarily impact your mood.",
  "27) Will it cost me money to take part in this research?",
  "28) There is no cost to you for participation.",
  "29) Will being in this research benefit me?",
  "30) There may be no direct benefit from participation.",
  "31) Possible indirect benefits include a reduction in anxiety and stress.",
  "32) What other choices do I have besides taking part in this research?",
  "33) You can choose not to participate.",
  "34) What information will you collect during this research?"
  "35) Personal information about you directly related to the research or as required to provide you with your participation payment.",
  "36) What happens to the information collected for this research?",
  "37) Your private personal information, including audio recordings, will only be shared with necessary parties.",
  "38) The audio recordings and survey responses will be maintained for at least three years following the completion of the study.",
  "39) When the study is over, email addresses will be deleted, and coding will be used to match the records going forward.",
  "40) Who can answer my questions about this research?",
  "41) The Research team is available to answer any questions, issues, or complaints.",
  "42) Can I be removed from this research without my approval?",
  "43) You may be removed without approval if it is in your best interest or if the research is canceled by the sponsor."
  "44) What happens if I agree to be in this research, but I change my mind later?"
  "45) If you decide to leave before completion, please inform the Research Coordinator.",
  "46) There is no penalty for leaving the study at any time, and all data collected up to that point will be discarded."
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: faqQuestions.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                return Text(
                  faqQuestions[index],
                  style: TextStyle(fontSize: 16),
                );
              },
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => PolicyPage(), // Replace with your policy page
                  ));
                },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF37AC6C), // Change the color here
                  ),
                child: Text("Accept"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: FAQPage()));
}
