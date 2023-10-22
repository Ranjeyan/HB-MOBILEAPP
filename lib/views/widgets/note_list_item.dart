import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../screens/quick_note_screen.dart';
import '../create_note.dart';

class NoteListItem extends StatelessWidget {
  const NoteListItem({super.key, required this.note});

  final Note note;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MaterialButton(
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
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 0.0,
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.black38,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note.title,
                        style: TextStyle(fontFamily: 'Helvetica',color: Colors.black54),
                        maxLines: 2,
                      ),
                      SizedBox(height: 5,),
                      Text(
                        note.description,
                        style: TextStyle(fontFamily: 'Helvetica',color: Colors.black),
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
