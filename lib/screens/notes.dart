import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NoteEditor extends StatefulWidget {
  final String initialTitle;
  final String initialContent;

  NoteEditor({required this.initialTitle, required this.initialContent});

  @override
  _NoteEditorState createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  // Initialize Firebase Authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  bool isTitleFocused = false;
  bool isNoteFocused = false;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.initialTitle;
    noteController.text = widget.initialContent;
  }

  // Function to get the current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Function to delete a note
  void deleteNote() async {
    final User? user = getCurrentUser();
    if (user != null) {
      final title = titleController.text;
      final note = noteController.text;
      final userEmail = user.email;

      // Check if the user is authenticated and the note belongs to the user
      if (userEmail != null) {
        // Perform the delete operation in Firestore
        await _firestore
            .collection('notes')
            .where('userEmail', isEqualTo: userEmail)
            .where('title', isEqualTo: title)
            .where('content', isEqualTo: note)
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.delete();
          });
        });

        // Navigate back after deleting
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
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
            icon: Icon(Icons.arrow_back, color: Color(0XFFD4AF37)),
            onPressed: () {
              final title = titleController.text;
              final note = noteController.text;
              Navigator.pop(context, {'action': 'save', 'title': title, 'note': note});
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.push_pin, color: Color(0XFFD4AF37)),
              onPressed: () {
                // Implement your pin functionality here
              },
            ),
            IconButton(
              icon: Icon(Icons.notifications, color: Color(0XFFD4AF37)),
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
                onTap: () {
                  setState(() {
                    isTitleFocused = true;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: isTitleFocused
                        ? Border.all(color: Color(0XFFD4AF37))
                        : null,
                  ),
                  child: TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: TextStyle(
                          color: Color(0XFFD4AF37),
                          fontSize: 26,
                          fontFamily: 'Helvetica'),
                      border: InputBorder.none,
                    ),
                    cursorColor: Color(0XFFD4AF37),
                    style: TextStyle(color: Color(0XFFD4AF37)),
                  ),
                ),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isNoteFocused = true;
                  });
                },
                child: Container(
                  child: TextField(
                    controller: noteController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      labelText: 'Note',
                      labelStyle: TextStyle(
                          color: Color(0XFFD4AF37),
                          fontSize: 18,
                          fontFamily: 'Helvetica'),
                      border: InputBorder.none,
                    ),
                    cursorColor: Color(0XFFD4AF37),
                    style: TextStyle(color: Color(0XFFD4AF37)),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Show the bottom sheet for actions
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
                        onPressed: deleteNote,
                      ),
                      _buildBottomSheetItem(
                        icon: Icons.send,
                        text: 'Send',
                        onPressed: () {
                          // Implement send functionality here
                        },
                      ),
                      _buildBottomSheetItem(
                        icon: Icons.copy,
                        text: 'Make a Copy',
                        onPressed: () {
                          // Implement make a copy functionality here
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
          backgroundColor: Color(0XFFD4AF37),
          child: Icon(Icons.more_vert, color: Color(0XFF00463C)),
        ),
      ),
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
}
