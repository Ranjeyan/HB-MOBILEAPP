import 'package:flutter/material.dart';

class AssessmentsScreen extends StatefulWidget {
  @override
  _AssessmentsScreenState createState() => _AssessmentsScreenState();
}

class _AssessmentsScreenState extends State<AssessmentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('Assessment', style: TextStyle(fontFamily: 'Helvetica', color: Colors.black54),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black45,),
          onPressed: () {},
        ),
      ),
      body: Center(
        child: Container(
          width: 400, // You can adjust the width as needed
          height: 100, // You can adjust the height as needed
          decoration: BoxDecoration(
            color: Colors.black, // You can change the background color
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0), // Adjust the left padding as needed
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                  children: [
                    Text(
                      'Assessments',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontFamily: 'Helvetica',
                      ),
                    ),
                    SizedBox(height: 10), // Add some spacing
                    Text(
                      'Understand your health better',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white, // You can change the text color
                        fontFamily: 'Helvetica',
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(), // Empty container to push the image to the right
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0), // Match the container's border radius
                child: Image(
                  image: AssetImage('assets/images/asses.png'), // Replace with your image asset
                  width: 140, // You can adjust the width of the image
                  height: 100, // You can adjust the height of the image
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
