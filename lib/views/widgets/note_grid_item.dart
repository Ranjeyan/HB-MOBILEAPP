import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:google_fonts/google_fonts.dart';

import '../../screens/quick_note_screen.dart';
import '../create_note.dart';

class NoteGridItem extends StatelessWidget {
  const NoteGridItem({super.key, required this.note});

  final Note note;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double containerWidth = constraints.maxWidth - 10; // Subtract 10 for padding

        return MaterialButton(
          onPressed: () async {
            // Convert the Note object to a DocumentSnapshot
            final snapshot = await FirebaseFirestore.instance
                .collection('notes')
                .doc(note.id)
                .get();

            // Pass the DocumentSnapshot to CreateNoteView
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CreateNoteView(note: snapshot, key: UniqueKey(),),
            ));
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.zero,
          elevation: 0.0,
          child: Container(
            width: containerWidth,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.black38,
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.title,
                  style: TextStyle(fontFamily: 'Helvetica', color: Colors.black54, fontSize: 18),
                  maxLines: 2,
                ),
                Flexible(
                  child: Text(
                    note.description,
                    style: TextStyle(fontFamily: 'Helvetica', fontSize: 15,color: Colors.black),
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
