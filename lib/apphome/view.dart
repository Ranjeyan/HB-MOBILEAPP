import 'package:flutter/material.dart';

import 'Quotes.dart';

class HomeView extends StatefulWidget {
  final String userName;
  final int selectedEmotion;
  final VoidCallback onAssessmentPressed;

  const HomeView({
  Key? key,
  required this.userName,
  required this.selectedEmotion,
  required this.onAssessmentPressed,
}) : super(key: key);

@override
_HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
int _selectedEmotion = -1;

@override
Widget build(BuildContext context) {
return SingleChildScrollView(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Padding(
padding: const EdgeInsets.only(top: 86, left: 20),
child: Row(
children: [
const Text(
'Hey, ',
style: TextStyle(
fontSize: 28.0,
color: Colors.black54,
fontFamily: 'Helvetica',
),
),
Text(
widget.userName,
style: const TextStyle(
fontSize: 28.0,
color: Colors.black54,
fontFamily: 'Helvetica',
),
),
],
),
),
const SizedBox(height: 30),
// Add QuotesWidget here
QuotesWidget(),
const SizedBox(height: 20),
Container(
decoration: BoxDecoration(
color: Colors.black12,
borderRadius: BorderRadius.circular(12),
),
margin: const EdgeInsets.all(10),
padding: const EdgeInsets.all(20),
child: Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Text(
'Assess & Understand',
style: TextStyle(
fontSize: 24.0,
color: Colors.black,
fontFamily: 'Lora',
),
),
InkWell(
onTap: () {
widget.onAssessmentPressed();
Navigator.of(context).pushNamed('/assessment-detail');
},
child: const Icon(
Icons.arrow_circle_right_outlined,
color: Colors.black,
size: 36.0,
),
),
],
),
),
const SizedBox(height: 50),
if (_selectedEmotion != -1)
Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Padding(
padding: EdgeInsets.only(left: 20),
child: Text(
'You are feeling:',
style: TextStyle(
fontSize: 28.0,
color: Colors.black54,
fontFamily: 'Lora',
),
),
),
const SizedBox(height: 10),
Card(
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
),
margin: const EdgeInsets.all(10),
color: _getEmotionColor(_selectedEmotion),
child: ListTile(
title: Text(
_getEmotionLabel(_selectedEmotion),
style: const TextStyle(
color: Colors.black,
fontSize: 16,
fontFamily: 'Helvetica',
),
),
),
),
],
)
else
Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Padding(
padding: EdgeInsets.only(left: 20),
child: Text(
'How are you feeling today?',
style: TextStyle(
fontSize: 28.0,
color: Colors.black54,
fontFamily: 'Lora',
),
),
),
const SizedBox(height: 10),
Container(
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(12),
),
margin: const EdgeInsets.all(10),
child: GridView.builder(
shrinkWrap: true,
physics: const ClampingScrollPhysics(),
gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
crossAxisCount: 3,
childAspectRatio: 1.0,
),
itemCount: 7,
itemBuilder: (BuildContext context, int index) {
return Card(
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
),
margin: const EdgeInsets.all(10),
color: _getEmotionColor(index),
child: Stack(
children: [
ListTile(
title: Text(
_getEmotionLabel(index),
style: const TextStyle(
color: Colors.black,
fontSize: 12,
fontFamily: 'Helvetica',
),
),
onTap: () {
setState(() {
_selectedEmotion = index;
});
},
),
Positioned(
bottom: 0,
right: 0,
child: Image.asset(
_getEmotionImage(index), // Provide the path to the image
width: 24, // Adjust the width as needed
height: 24, // Adjust the height as needed
),
),
],
),
);
},
),
),
],
),
],
),
);
}

Color _getEmotionColor(int index) {
final List<Color> colors = [
const Color(0XFF51e2f5), // Happy
const Color(0XFF9df9ef), // Sad
const Color(0XFFedf756), // Angry
const Color(0XFFffa8B6), // Excited
const Color(0XFFa28089),
const Color(0XFFa0d2eb),
const Color(0XFFd0bdf4),
];

return colors[index];
}

String _getEmotionLabel(int index) {
final List<String> labels = [
'Happy',
'Sad',
'Angry',
'Excited',
'Stress',
'Anxiety',
'Depression',
];

return labels[index];
}

String _getEmotionImage(int index) {
final List<String> imagePaths = [
'assets/emojis/happy.png',
'assets/emojis/sad.png',
'assets/emojis/angry.png',
'assets/emojis/excited.png',
'assets/emojis/stress.png',
'assets/emojis/anxiety.png',
'assets/emojis/depression.png',
];

return imagePaths[index];
}
}
