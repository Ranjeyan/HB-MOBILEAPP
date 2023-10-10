import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'notes.dart';

void main() {
  runApp(QuickNotesApp());
}

class QuickNotesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: QuickNotesScreen(),
    );
  }
}

class QuickNotesScreen extends StatefulWidget {
  @override
  _QuickNotesScreenState createState() => _QuickNotesScreenState();
}

class _QuickNotesScreenState extends State<QuickNotesScreen> {
  List<Note> notes = [];
  List<int> selectedCards = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _notesCollection =
  FirebaseFirestore.instance.collection('notes');

  late User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
  }

  String? getCurrentUserEmail() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.email;
    }
    return null;
  }

  void addNote(String title, String content) {
    final userEmail = getCurrentUserEmail();
    if (userEmail != null) {
      _notesCollection.add({
        'title': title,
        'content': content,
        'userEmail': userEmail,
      }).then((value) {
        setState(() {
          notes.add(Note(title: title, content: content));
        });
      });
    }
  }

  void editNote(int index, String title, String content) {
    final userEmail = getCurrentUserEmail();
    if (userEmail != null) {
      setState(() {
        notes[index] = Note(title: title, content: content);
      });

      _notesCollection.doc(notes[index].title).update({
        'title': title,
        'content': content,
        'userEmail': userEmail,
      });
    }
  }

  void toggleSelect(int index) {
    setState(() {
      if (selectedCards.contains(index)) {
        selectedCards.remove(index);
      } else {
        selectedCards.add(index);
      }
    });
  }

  void handleAction(String action) {
    if (action == 'delete' && _currentUser != null) {
      for (var index in selectedCards) {
        _notesCollection.doc(notes[index].title).delete();
        notes.removeAt(index);
      }
      selectedCards.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF00463C),
      appBar: AppBar(
        backgroundColor: Color(0XFF00463C),
        elevation: 0,
        title: Text(
          'Mental Wellness Tracker',
          style: TextStyle(fontFamily: 'Helvetica'),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          if (selectedCards.isNotEmpty)
            IconButton(
              icon: Icon(Icons.push_pin),
              onPressed: () => handleAction('pin'),
            ),
          if (selectedCards.isNotEmpty)
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () => handleAction('notify'),
            ),
          if (selectedCards.isNotEmpty && _currentUser != null)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => handleAction('delete'),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: _notesCollection
              .where('userEmail', isEqualTo: getCurrentUserEmail())
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            notes.clear();

            snapshot.data!.docs.forEach((document) {
              notes.add(Note(
                title: document['title'],
                content: document['content'],
              ));
            });

            return ListView.builder(
              shrinkWrap: true,
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return NoteCard(
                  note: notes[index],
                  isSelected: selectedCards.contains(index),
                  onEdit: (String title, String content) {
                    editNote(index, title, content);
                  },
                  onLongPress: () {
                    toggleSelect(index);
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FabOptions(addNote: addNote),
    );
  }
}

class FabOptions extends StatefulWidget {
  final Function(String, String) addNote;

  FabOptions({required this.addNote});

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
                      onPressed: () async {
                        _toggleFabOptions();
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                NoteEditor(initialTitle: '', initialContent: ''),
                          ),
                        );

                        if (result != null) {
                          String title = result['title'];
                          String note = result['note'];
                          widget.addNote(title, note);
                        }
                      },
                      child: Icon(Icons.mic),
                    ),
                    SizedBox(height: 16),
                    FloatingActionButton(
                      backgroundColor: Color(0XFFF06151),
                      onPressed: () async {
                        _toggleFabOptions();
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                NoteEditor(initialTitle: '', initialContent: ''),
                          ),
                        );

                        if (result != null) {
                          String title = result['title'];
                          String note = result['note'];
                          widget.addNote(title, note);
                        }
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

class NoteCard extends StatefulWidget {
  final Note note;
  final bool isSelected;
  final Function(String title, String content) onEdit;
  final Function onLongPress;

  NoteCard({
    required this.note,
    required this.isSelected,
    required this.onEdit,
    required this.onLongPress,
  });

  @override
  _NoteCardState createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
  }

  void _toggleSelected() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        widget.onLongPress();
        _toggleSelected();
      },
      onTap: () {
        if (!_isSelected) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteEditor(
                initialTitle: widget.note.title ?? '',
                initialContent: widget.note.content ?? '',
              ),
            ),
          ).then((result) {
            if (result != null) {
              String editedTitle = result['title'];
              String editedContent = result['note'];
              widget.onEdit(editedTitle, editedContent);
            }
          });
        } else {
          widget.onLongPress();
          _toggleSelected();
        }
      },
      child: Container(
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: _isSelected ? Color(0XFFF06151) : Color(0XFFD4AF37),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ListTile(
          title: Text(
            widget.note.title ?? '',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Color(0XFFD4AF37)),
          ),
          subtitle: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              widget.note.content ?? '',
              style: TextStyle(fontSize: 16.0, color: Color(0XFFD4AF37)),
            ),
          ),
        ),
      ),
    );
  }
}

class Note {
  final String title;
  final String content;

  Note({
    required this.title,
    required this.content,
  });
}
