import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class QuotesWidget extends StatefulWidget {
  @override
  _QuotesWidgetState createState() => _QuotesWidgetState();
}

class _QuotesWidgetState extends State<QuotesWidget> {
  List<String> quotes = [];
  int currentQuoteIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchQuotes(); // Fetch quotes when the widget is initialized.
  }

  Future<void> fetchQuotes() async {
    try {
      final response = await http.get(Uri.parse('https://type.fit/api/quotes'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          quotes = data.map((quote) => quote['text'] as String).toList();
        });
      }
    } catch (e) {
      print("Error fetching quotes: $e");
    }
  }

  void changeQuote() {
    if (quotes.isNotEmpty) {
      setState(() {
        currentQuoteIndex = (currentQuoteIndex + 1) % quotes.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                quotes.isNotEmpty ? quotes[currentQuoteIndex] : "Fetching quotes...",
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontFamily: 'Lora',
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  icon: Icon(Icons.refresh_rounded, size: 30),
                  onPressed: changeQuote,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
