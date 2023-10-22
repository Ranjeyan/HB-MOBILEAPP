import 'package:flutter/material.dart';
import 'package:healingbee/screens/sign_in_page.dart';
import '../content_model.dart';

class DetailScreen extends StatefulWidget {
  final String userName;
  final String email;

  DetailScreen({required this.userName, required this.email});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 70), // Add some space at the top
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: contents.length,
              onPageChanged: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (_, i) {
                return Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Image.asset(
                        contents[i].image,
                        height: 300,
                      ),
                      SizedBox(height: 20,),
                      Text(
                        contents[i].title,
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color:Colors.black
                        ),
                      ),
                      SizedBox(height: 25),
                      Text(
                        contents[i].discription,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                          fontFamily: 'Helvetica'
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  contents.length,
                      (index) => buildDot(index, context),
                ),
              ),
            ),
          ),
          SizedBox(height: 50), // Add some space between dots and button
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 60,
              margin: EdgeInsets.only(bottom: 150), // Adjust the top margin here
              width: 400,
              child: TextButton(
                child: Text(
                  currentIndex == contents.length - 1 ? "Get Started" : "Next",style: TextStyle(fontFamily: 'Helvetica',fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  if (currentIndex == contents.length - 1) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HomePage(
                        ),
                      ),
                    );
                  }
                  _controller.nextPage(
                    duration: Duration(milliseconds: 100),
                    curve: Curves.bounceIn,
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.black,
                  primary: Colors.white38,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: currentIndex == index ? 25 : 10,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black54,
      ),
    );
  }
}
