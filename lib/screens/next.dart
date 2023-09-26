import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healingbee/screens/Page-one.dart';

class NextPage extends StatelessWidget {
  final String userName;

  NextPage({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ... existing code ...
      body: SafeArea(
        child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.w200,
                      color: Colors.black,
                      fontFamily: "lufga",
                    ),
                    children: [
                      TextSpan(
                        text: 'Hello there ',
                      ),
                      TextSpan(
                        text: ' 😀', // Unicode character for a smile emoji
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.0), // Add some space between the text
                Text(
                  'How should we identify you?',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.w200,
                    color: Colors.black54,
                    fontFamily: "YukitaSans",
                  ),
                ),
                SizedBox(height: 36.0), // Add some space between the text and input field
                TextField(
                  controller: TextEditingController(text: userName), // Set the initial value
                  onChanged: (value) {
                    // Update the userName variable if needed
                  },
                  style: TextStyle(
                    fontFamily: 'lufga', // Replace 'YourDesiredFontFamily' with the desired font family
                    fontSize: 16.0, // Adjust the font size as needed
                    color: Colors.black, // Customize the text color
                  ),
                  decoration: InputDecoration(
                    hintText: 'your nickname or pseudonym?',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black, // Customize the color of the underline
                      ),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        if (userName.isEmpty) {
                          showErrorMessage(context); // Show error message if name is empty
                        } else {
                          // Navigate to the next page here
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AppEntryPage(), // Replace with your next page
                            ),
                          );
                        }
                      },
                      child: Icon(
                        Icons.arrow_forward, // You can replace this with your desired arrow icon
                        color: Colors.black, // Customize the icon color
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 36.0), // Add some space below the text field
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (userName.isEmpty) {
                        showErrorMessage(context); // Show error message if name is empty
                      } else {
                        // Navigate to the AppEntryPage here
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AppEntryPage(), // Replace with your next page
                          ),
                        );
                      }
                    },
                    child: Text('Done', style: TextStyle(fontFamily: "lufga")),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0), // Adjust the value for rounded edges
                      ),
                      primary: Colors.black, // Change the button color to black
                      minimumSize: Size(150.0, 60.0),
                      elevation: 0, // Set the button size
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showErrorMessage(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('Please enter your name.'),
      duration: Duration(seconds: 2), // You can adjust the duration as needed
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

