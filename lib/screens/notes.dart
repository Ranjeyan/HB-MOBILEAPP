import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NoteEditor extends StatefulWidget {
  final String initialTitle;
  final String initialContent;

  // Add the constructor that accepts initial values
  NoteEditor({required this.initialTitle, required this.initialContent});

  @override
  _NoteEditorState createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  bool isTitleFocused = false;
  bool isNoteFocused = false;

  @override
  void initState() {
    super.initState();

    // Set initial values when the widget is initialized
    titleController.text = widget.initialTitle;
    noteController.text = widget.initialContent;
  }

  void _onTitleTap() {
    setState(() {
      isTitleFocused = true;
    });
  }

  void _onNoteTap() {
    setState(() {
      isNoteFocused = true;
    });
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Color(0XFF00463C),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildBottomSheetItem(
                icon: Icons.delete,
                text: 'Delete',
                onPressed: () {
                  // Implement delete functionality here
                  _deleteNote(); // Call your delete method
                  Navigator.pop(context); // Close the bottom sheet
                },
              ),
              _buildBottomSheetItem(
                icon: Icons.send,
                text: 'Send',
                onPressed: () {
                  // Implement send functionality here
                  _sendNote(); // Call your send method
                  Navigator.pop(context); // Close the bottom sheet
                },
              ),
              _buildBottomSheetItem(
                icon: Icons.copy,
                text: 'Make a Copy',
                onPressed: () {
                  // Implement make a copy functionality here
                  _makeCopy(); // Call your make a copy method
                  Navigator.pop(context); // Close the bottom sheet
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomSheetItem({IconData? icon, String? text, VoidCallback? onPressed}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        text ?? '',
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
      onTap: onPressed,
    );
  }

  void _deleteNote() {
    // Implement delete functionality here
    final title = titleController.text;
    final note = noteController.text;

    // Perform the delete operation based on your data source
    // For example, you can use Firestore to delete the note

    // After deleting, you might want to navigate back or perform any necessary updates
    Navigator.pop(context, {'action': 'delete', 'title': title, 'note': note});
  }

  void _sendNote() {
    // Implement send functionality here
    final title = titleController.text;
    final note = noteController.text;

    // Perform the send operation based on your requirements
    // For example, you can send the note through email or messaging

    // After sending, you might want to navigate back or perform any necessary updates
    Navigator.pop(context, {'action': 'send', 'title': title, 'note': note});
  }

  void _makeCopy() {
    // Implement make a copy functionality here
    final title = titleController.text;
    final note = noteController.text;

    // Create a copy of the note and handle it based on your data source
    // For example, you can duplicate the note in Firestore

    // After making a copy, you might want to navigate back or perform any necessary updates
    Navigator.pop(context, {'action': 'copy', 'title': title, 'note': note});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Automatically save the note when the user navigates back
        final title = titleController.text;
        final note = noteController.text;
        Navigator.pop(context, {'action': 'save', 'title': title, 'note': note});
        return true;
      },
      child: Scaffold(
        backgroundColor: Color(0XFF00463C),
        appBar: AppBar(
          backgroundColor: Color(0XFF00463C),
          elevation: 0,
          title: Text(''),
          leading: IconButton(
            icon: Icon(Icons.arrow_back,color: Color(0XFFD4AF37),),
            onPressed: () {
              // Save the note
              final title = titleController.text;
              final note = noteController.text;
              Navigator.pop(context, {'action': 'save', 'title': title, 'note': note});
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.push_pin,color: Color(0XFFD4AF37),),
              onPressed: () {
                // Implement your pin functionality here
              },
            ),
            IconButton(
              icon: Icon(Icons.notifications,color: Color(0XFFD4AF37),),
              onPressed: () {
                // Implement your notification functionality here
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _onTitleTap,
                child: Container(
                  decoration: BoxDecoration(
                    border: isTitleFocused
                        ? Border.all(color: Color(0XFFD4AF37)) // Add border when focused
                        : null,
                  ),
                  child: TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: TextStyle(color: Color(0XFFD4AF37), fontSize: 26,fontFamily: 'Helvetica'),
                      border: InputBorder.none, // Remove the underline
                    ),
                    cursorColor: Color(0XFFD4AF37), // Set cursor color
                    style: TextStyle(color: Color(0XFFD4AF37)), // Set input text color
                  ),
                ),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: _onNoteTap,
                child: Container(
                  child: TextField(
                    controller: noteController,
                    maxLines: null, // Allow multiple lines
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      labelText: 'Note',
                      labelStyle: TextStyle(color: Color(0XFFD4AF37), fontSize: 18,fontFamily: 'Helvetica'),
                      border: InputBorder.none, // Remove the underline
                    ),
                    cursorColor: Color(0XFFD4AF37), // Set cursor color
                    style: TextStyle(color: Color(0XFFD4AF37)), // Set input text color
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showBottomSheet(context);
          },
          backgroundColor: Color(0XFFD4AF37),
          child: Icon(Icons.more_vert,color: Color(0XFF00463C),),
        ),
      ),
    );
  }
}
