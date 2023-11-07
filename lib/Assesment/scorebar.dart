import 'package:flutter/material.dart';

class ScoreBar extends StatelessWidget {
  final int score;
  final double barWidth;
  final double barHeight;
  final double borderRadius;
  final double arrowPosition;
  final List<Color> barColors;

  ScoreBar(this.score, {
    this.barWidth = 350.0,
    this.barHeight = 30.0,
    this.borderRadius = 20.0,
    this.arrowPosition = 0.0,
    this.barColors = const [Colors.green, Colors.orange, Colors.red],
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: barWidth,
        height: barHeight,
        child: CustomPaint(
          painter: ScoreBarPainter(
            score.toDouble(), // Cast score to double
            barColors,
            arrowPosition.toDouble(), // Cast arrowPosition to double
            barWidth.toDouble(), // Cast barWidth to double
          ),
        ),
      ),
    );
  }
}

class ScoreBarPainter extends CustomPainter {
  final double score; // Change to double
  final List<Color> barColors;
  final double arrowPosition; // Change to double
  final double barWidth; // Change to double

  ScoreBarPainter(this.score, this.barColors, this.arrowPosition, this.barWidth);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    // Draw the background bar
    final backgroundRect = Rect.fromPoints(Offset(0, 0), Offset(barWidth, size.height));
    final backgroundPath = Path()..addRRect(RRect.fromRectAndRadius(backgroundRect, Radius.circular(20.0)));
    paint.color = Colors.grey; // Background color
    canvas.drawPath(backgroundPath, paint);

    // Calculate the score position within the bar
    final scorePosition = (score / 27) * barWidth;

    // Draw the colored portions of the bar
    final barWidths = [
      (scorePosition < arrowPosition) ? scorePosition : arrowPosition,
      (scorePosition > arrowPosition) ? scorePosition - arrowPosition : 0,
      (scorePosition > arrowPosition) ? barWidth - scorePosition : 0,
    ];

    final colorStops = [0.0, arrowPosition / barWidth, 1.0];

    final colorShader = LinearGradient(
      colors: barColors,
      stops: colorStops,
    ).createShader(Rect.fromPoints(Offset(0, 0), Offset(barWidth, 0)));

        for (var i = 0; i < 3; i++) {
      if (barWidths[i] > 0) {
        final rect = Rect.fromPoints(
          Offset(i == 0 ? 0 : (i == 1 ? arrowPosition : scorePosition), 0),
          Offset(i == 0 ? barWidths[i].toDouble() : scorePosition, size.height),
          // Explicitly cast barWidths[i] to double here
        );
        final path = Path()..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(20.0)));

        paint.shader = colorShader;
        canvas.drawPath(path, paint);
      }
    }

    // Draw the arrow
    final arrowPath = Path()
      ..moveTo(scorePosition, -10) // Arrow tip
      ..lineTo(scorePosition - 10, -30)
      ..lineTo(scorePosition + 10, -30)
      ..close();

    paint.color = Colors.black;
    canvas.drawPath(arrowPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: Center(
        child: ScoreBar(15),
      ),
    ),
  ));
}
