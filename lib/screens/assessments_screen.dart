import 'package:flutter/material.dart';

class AssessmentsScreen extends StatefulWidget {
  @override
  _AssessmentsScreenState createState() => _AssessmentsScreenState();
}

class _AssessmentsScreenState extends State<AssessmentsScreen> {
  int selectedEmoji = -1; // Initialize with no emoji selected

  // Function to handle emoji selection
  void selectEmoji(int index) {
    setState(() {
      selectedEmoji = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // List of emojis
    List<EmojiTile> emojiTiles = [
      EmojiTile(index: 0, emoji: '😄', label: 'Happy', selectEmoji: selectEmoji),
      EmojiTile(index: 1, emoji: '😐', label: 'Neutral', selectEmoji: selectEmoji),
      EmojiTile(index: 2, emoji: '😢', label: 'Sad', selectEmoji: selectEmoji),
      EmojiTile(index: 3, emoji: '😫', label: 'Stress', selectEmoji: selectEmoji),
      EmojiTile(index: 4, emoji: '😰', label: 'Anxiety', selectEmoji: selectEmoji),
      EmojiTile(index: 5, emoji: '😞', label: 'Depression', selectEmoji: selectEmoji),
    ];

    return Scaffold(
      backgroundColor:Color(0XFF00463C) ,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0XFF00463C),
        title: Text('Assessment',style: TextStyle(fontFamily: 'Helvetica'),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), onPressed: () {  }, // Add the back arrow icon

        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'How are you feeling today?',
              style: TextStyle(fontSize: 20.0,color: Color(0XFFD4AF37),fontFamily: 'Helvetica'),
            ),
            SizedBox(height: 16.0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Enable horizontal scrolling
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: emojiTiles,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              selectedEmoji == -1
                  ? 'Select an emoji to express your feelings'
                  : 'You selected: ${emojiTiles[selectedEmoji].label}',
              style: TextStyle(fontSize: 16.0,color: Color(0XFFD4AF37),fontFamily: 'Helvetica'),
            ),
          ],
        ),
      ),
    );
  }
}

class EmojiTile extends StatelessWidget {
  final int index;
  final String emoji;
  final String label;
  final Function(int) selectEmoji;

  EmojiTile({required this.index, required this.emoji, required this.label, required this.selectEmoji});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle emoji selection
        selectEmoji(index);
      },
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: index == selectEmoji ? Colors.blue : Color(0XFFD4AF37),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: index == selectEmoji ? Color(0XFFF06151)  : Color(0XFFD4AF37),
            width: 2.0,
          ),
        ),
        child: Column(
          children: [
            Text(
              emoji,
              style: TextStyle(fontSize: 32.0),
            ),
            SizedBox(height: 8.0),
            Text(
              label,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AssessmentsScreen(),
  ));
}
