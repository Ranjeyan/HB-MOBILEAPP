import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Set the status bar color to white
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Color(0XFF00463C),
    ));

    return Scaffold(
      backgroundColor: Color(0XFF00463C),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor:Color(0XFF00463C),
            elevation: 0.0,
            expandedHeight: 80.0, // Reduced AppBar size
            pinned: true,
            title: Text(
              "Privacy Policy",
              style: TextStyle(
                color: Color(0XFFD4AF37),
                fontFamily: "Poppins",
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Color(0XFFD4AF37),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Transform.translate(
                    offset: Offset(0, -40), // Adjust this value to move up
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.menu,
                            color: Color(0XFFD4AF37),
                          ),
                          onPressed: () {
                            // Handle menu icon press
                          },
                          iconSize: 35,
                        ),
                        SizedBox(width:125,),
                        Image.asset(
                          'assets/images/logo1.png',
                          width: 100,
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Transform.translate(
                        offset: Offset(0, -40), // Adjust this value to move up
                        child: Text(
                          "Privacy",
                          style: TextStyle(
                            fontSize: 40,
                            fontFamily: "lufga",
                            color: Color(0XFFD4AF37),
                          ),
                        ),
                      ),
                      SizedBox(height: 3), // Vertical spacing
                      Transform.translate(
                        offset: Offset(0, -40), // Adjust this value to move up
                        child: Text(
                          "Policy",
                          style: TextStyle(
                            fontSize: 40,
                            fontFamily: "lufga",
                            color:Color(0XFFD4AF37),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Transform.translate(
                    offset: Offset(0, -20), // Adjust this value to move up
                    child: Text(
                      "Effective Date: 28th June 2023",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Poppins",
                        color: Color(0XFFF06151),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "At Black Dot Innovations Pvt Ltd ('Company'),\n",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Gotham",
                            color: Color(0XFFD4AF37),
                          ),
                        ),
                        WidgetSpan(
                          child: SizedBox(height: 10), // Adjust the height as needed
                        ),
                        TextSpan(
                          text: "we are committed to protecting the privacy of our users.\n",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Gotham",
                            color: Color(0XFFD4AF37),
                          ),
                        ),
                        WidgetSpan(
                          child: SizedBox(height: 10), // Adjust the height as needed
                        ),
                        TextSpan(
                          text: "This Privacy Policy outlines how we collect, use, and disclose personal information when you participate in our survey using the Aidaform form creator platform.\n",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Gotham",
                            color: Color(0XFFD4AF37),
                          ),
                        ),
                        WidgetSpan(
                          child: SizedBox(height: 10), // Adjust the height as needed
                        ),
                        TextSpan(
                          text: "Please read this Privacy Policy carefully to understand our practices regarding your personal information.\n",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Gotham",
                            color: Color(0XFFD4AF37),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20), // Add space between sections

                  // Next section
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Information We Collect :\n",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Poppins",
                            color: Color(0XFFF06151),
                          ),
                        ),
                        WidgetSpan(
                          child: SizedBox(height: 10), // Adjust the height as needed
                        ),
                        TextSpan(
                          text: "When you participate in our survey, we may collect the following types of information:\n\n",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Gotham",
                            color: Color(0XFFD4AF37),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20), // Add space between sections

                  // Next section
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Use of Information :\n",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Poppins",
                            color: Color(0XFFF06151),
                          ),
                        ),
                        WidgetSpan(
                          child: SizedBox(height: 10), // Adjust the height as needed
                        ),
                        TextSpan(
                          text: "We use the collected information for the following purposes:\n\n",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Gotham",
                            color: Color(0XFFD4AF37),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20), // Add space between sections

                  // Next section
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Third-Party Service Provider :\n",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Poppins",
                            color:Color(0XFFF06151),
                          ),
                        ),
                        WidgetSpan(
                          child: SizedBox(height: 10), // Adjust the height as needed
                        ),
                        TextSpan(
                          text: "We use the Aidaform form creator platform as a third-party service provider to collect the survey responses and audio recordings. As such, your personal information may be subject to Aidaform's privacy policy. We encourage you to review Aidaform's privacy policy at https://aidaform.com/privacy-policy.html to understand how they handle your personal information.\n\n",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Gotham",
                            color:Color(0XFFD4AF37),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20), // Add space between sections

                  // Next section
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Data Retention and Security :\n",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Poppins",
                            color:Color(0XFFF06151),
                          ),
                        ),
                        WidgetSpan(
                          child: SizedBox(height: 10), // Adjust the height as needed
                        ),
                        TextSpan(
                          text: "We retain the collected information for as long as necessary to fulfill the purposes outlined in this Privacy Policy unless a longer retention period is required or permitted by law. We take reasonable measures to protect your personal information from unauthorized access, use, or disclosure.\n\n",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Gotham",
                            color: Color(0XFFD4AF37),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20), // Add space between sections

                  // Next section
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Disclosure of Information :\n",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Poppins",
                            color: Color(0XFFF06151),
                          ),
                        ),
                        WidgetSpan(
                          child: SizedBox(height: 10), // Adjust the height as needed
                        ),
                        TextSpan(
                          text: "We do not disclose your personal information to third parties unless required by law or with your consent. However, please note that Aidaform may collect, process, and store your personal information in accordance with their privacy policy.\n\n",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Gotham",
                            color: Color(0XFFD4AF37),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20), // Add space between sections

                  // Next section
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Your Rights :\n",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Poppins",
                            color: Color(0XFFF06151),
                          ),
                        ),
                        WidgetSpan(
                          child: SizedBox(height: 10), // Adjust the height as needed
                        ),
                        TextSpan(
                          text: "You have certain rights regarding your personal information, including the right to access, correct, or delete your personal information. If you wish to exercise these rights or have any questions about our privacy practices, please contact us at hello@blackdotinnovation.com\n\n",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Gotham",
                            color: Color(0XFFD4AF37),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20), // Add space between sections

                  // Next section
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Changes to the Privacy Policy :\n",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Poppins",
                            color: Color(0XFFF06151),
                          ),
                        ),
                        WidgetSpan(
                          child: SizedBox(height: 10), // Adjust the height as needed
                        ),
                        TextSpan(
                          text: "We reserve the right to modify or update this Privacy Policy at any time. We will provide notice of any material changes by posting the revised Privacy Policy on our website or through other means.\n\n",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Gotham",
                            color: Color(0XFFD4AF37),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20), // Add space between sections

                  // Next section
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Contact Us :\n",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Poppins",
                            color: Color(0XFFF06151),
                          ),
                        ),
                        WidgetSpan(
                          child: SizedBox(height: 10), // Adjust the height as needed
                        ),
                        TextSpan(
                          text: "If you have any questions, concerns, or requests regarding this Privacy Policy or our privacy practices, please contact us at hello@blackdotinnovation.com\n\n",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Gotham",
                            color: Color(0XFFD4AF37),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20), // Add space between sections

                  // Last section
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "By participating in our survey, you acknowledge that you have read and understood this Privacy Policy and agree to the collection, use, and disclosure of your personal information as described herein.\n",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Gotham",
                            color: Color(0XFFD4AF37),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DetailsScreen(),
    theme: ThemeData(
      appBarTheme: AppBarTheme(
        elevation: 0, // Remove AppBar shadow
      ),
    ),
  ));
}
