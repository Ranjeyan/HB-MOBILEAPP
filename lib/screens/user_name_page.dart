import 'package:flutter/material.dart';
import 'package:healingbee/screens/App_home_page.dart';

class NextPage extends StatefulWidget {
  final String userName; // Add this line

  NextPage({required this.userName});
  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  String userName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      fontSize: 35.0,
                      fontWeight: FontWeight.w200,
                      color: Color(0XFF024022),
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
                SizedBox(height: 30.0),
                Text(
                  'How should we identify you?',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w200,
                    color: Colors.black54,
                    fontFamily: "YukitaSans",
                  ),
                ),
                SizedBox(height: 36.0),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      userName = value; // Update the userName variable when the text field changes
                    });
                  },
                  style: TextStyle(
                    fontFamily: 'lufga',
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Your nickname or pseudonym?',
                    hintStyle: TextStyle(color: Color(0XFF024022)),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0XFF024022),
                      ),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        final args = ModalRoute.of(context)!.settings.arguments as String;
                        if (userName.trim().isEmpty) {
                          showErrorMessage(context); // Show error message if name is empty
                        } else {
                          // Navigate to the next page here
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AppEntryPage(userName: args,), // Replace with your next page
                            ),
                          );
                        }
                      },
                      child: Icon(
                        Icons.arrow_forward, // You can replace this with your desired arrow icon
                        color: Color(0XFF024022), // Customize the icon color
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 36.0), // Add some space below the text field
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (userName.trim().isEmpty) {
                        showErrorMessage(context); // Show error message if name is empty
                      } else {
                        // Navigate to the AppEntryPage here
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AppEntryPage(userName: 'Ran',), // Replace with your next page
                          ),
                        );
                      }
                    },
                    child: Text('Done', style: TextStyle(fontFamily: "lufga")),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20.0), // Adjust the value for rounded edges
                      ),
                      backgroundColor: Color(0XFF024022),
                      minimumSize: Size(150.0, 60.0),
                      elevation: 0,
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
      content: Text(
        'Please enter your name.',
        style: TextStyle(fontFamily: "lufga"),
      ),
      backgroundColor: Color(0XFF024022),
      duration: Duration(seconds: 2), // You can adjust the duration as needed
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
