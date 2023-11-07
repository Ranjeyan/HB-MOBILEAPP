import 'package:flutter/material.dart';
import 'package:healingbee/screens/quick_note_screen.dart';
import 'package:fl_chart/fl_chart.dart'; // Import the charts package
import '../Assesment/Assesment_detail.dart';
import 'App_home_page.dart';

class AssessmentsScreen extends StatefulWidget {
  const AssessmentsScreen({Key? key});

  @override
  _AssessmentsScreenState createState() => _AssessmentsScreenState();
}

class _AssessmentsScreenState extends State<AssessmentsScreen> {
  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const AssessmentsScreen(),
      ),
    );
    return false;
  }

  void _navigateToAssessmentDetailPage(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return AssessmentDetailPage();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(-1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('Assessment', style: TextStyle(fontFamily: 'Helvetica', color: Colors.black54)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black45),
          onPressed: () => _onWillPop(),
        ),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.only(bottom: 200),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  _navigateToAssessmentDetailPage(context);
                },
                child: Container(
                  width: 400,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 16.0, top: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Assessments',
                              style: TextStyle(fontSize: 18.0, color: Colors.white, fontFamily: 'Helvetica'),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Understand your health better',
                              style: TextStyle(fontSize: 14.0, color: Colors.white, fontFamily: 'Helvetica'),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: const Image(
                          image: AssetImage('assets/images/asses.png'),
                          width: 140,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => QuickNotes(),
                    ),
                  );
                },
                child: Container(
                  width: 400,
                  height: 70,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Center(
                    child: Text(
                      'Make your journal',
                      style: TextStyle(fontSize: 18.0, color: Colors.black, fontFamily: 'Helvetica'),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20), // Add some spacing
              Container(
                width: 400, // Set the width of the chart container
                height: 300, // Set the height of the chart container
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: 6, // Adjust the maximum value based on your data
                    minY: 0,
                    maxY: 30, // Adjust the maximum value based on your data
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          FlSpot(0, 10), // Replace with your actual data points
                          FlSpot(1, 15),
                          FlSpot(2, 12),
                          FlSpot(3, 18),
                          FlSpot(4, 22),
                          FlSpot(5, 28),
                        ],
                        isCurved: true,
                        color: Colors.blue, // Customize the line color
                        dotData: FlDotData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: Scaffold(
      body: AppEntryPage(user: null),
    ),
  ));
}
