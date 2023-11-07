import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';

import '../views/create_note.dart';
import '../views/widgets/notes_grid.dart';
import '../views/widgets/notes_list.dart';

class Note {
  final String title;
  final String description;
  final String content;
  final String id;

  Note({
    required this.title,
    required this.description,
    required this.content,
    required this.id,
  });
}

class QuickNotes extends StatefulWidget {
  const QuickNotes({Key? key});

  @override
  State<QuickNotes> createState() => _QuickNotesState();
}

class _QuickNotesState extends State<QuickNotes> {
  bool isListView = true;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Note',
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.black54,
                      fontFamily: 'Helvetica',
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isListView = !isListView;
                      });
                    },
                    icon: Icon(
                      isListView
                          ? Icons.splitscreen_outlined
                          : Icons.grid_view,
                      color: Colors.black54,
                      size: 32.0,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: _firestore
                    .collection('notes')
                    .where('userId', isEqualTo: _auth.currentUser?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData ||
                      snapshot.data == null ||
                      snapshot.data!.docs.isEmpty) {
                    return EmptyView();
                  } else {
                    final notes = (snapshot.data! as QuerySnapshot)
                        .docs
                        .map((doc) {
                      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                      return Note(
                        id: doc.id,
                        title: data['title'] ?? "",
                        description: data['description'] ?? "",
                        content: data['content'] ?? "", // Get the content
                      );
                    })
                        .toList();

                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: isListView
                          ? NotesList(notes: notes) // Display in list view
                          : NotesGrid(notes: notes), // Display in grid view
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double buttonWidth = constraints.maxWidth / 3.2;
            double buttonHeight = 56.0;

            return Container(
              width: buttonWidth,
              height: buttonHeight,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(buttonHeight / 2),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CreateNoteView(note: null, key: UniqueKey()),
                    ),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle_outline_rounded, color: Colors.white70, size: 24),
                    SizedBox(width: 10),
                    Text(
                      'Add Note',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        fontFamily: 'Helvetica',
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class EmptyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/json/empty.json'),
          const Text(
            'No notes available',
            style: TextStyle(fontSize: 18, color: Colors.black54, fontFamily: 'Helvetica'),
          ),
        ],
      ),
    );
  }
}
