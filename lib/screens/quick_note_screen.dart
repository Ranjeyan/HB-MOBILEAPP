import 'package:flutter/material.dart';

void main() {
  runApp(QuickNotesScreen());
}

class QuickNotesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0XFF00463C),
        appBar: AppBar(
          backgroundColor: Color(0XFF00463C),
          elevation: 0,
          title: Text('Mental Wellness Tracker'),
        ),
        body: Container(), // Remove the body content
        floatingActionButton: FabOptions(),
      ),
    );
  }
}

class FabOptions extends StatefulWidget {
  @override
  _FabOptionsState createState() => _FabOptionsState();
}

class _FabOptionsState extends State<FabOptions> {
  bool isFabOpen = false;

  void _toggleFabOptions() {
    setState(() {
      isFabOpen = !isFabOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: Column(
            children: [
              if (isFabOpen)
                Column(
                  children: [
                    FloatingActionButton(
                      backgroundColor: Color(0XFFF06151),
                      onPressed: () {
                        // Implement your action for the first option here
                        _toggleFabOptions();
                      },
                      child: Icon(Icons.mic),
                    ),
                    SizedBox(height: 16),
                    FloatingActionButton(
                      backgroundColor: Color(0XFFF06151),
                      onPressed: () {
                        // Implement your action for the second option here
                        _toggleFabOptions();
                      },
                      child: Icon(Icons.note_add),
                    ),
                  ],
                ),
              SizedBox(height: 16),
              FloatingActionButton(
                backgroundColor: Color(0XFFD4AF37),
                onPressed: _toggleFabOptions,
                child: Icon(isFabOpen ? Icons.close : Icons.add),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
