import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class CreateNoteView extends StatefulWidget {
  final DocumentSnapshot<Object?>? note;

  CreateNoteView({required this.note, required UniqueKey key}) : super(key: key);

  @override
  _CreateNoteViewState createState() => _CreateNoteViewState();
}

class _CreateNoteViewState extends State<CreateNoteView> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isPinned = false;
  String lastChanges = "";
  String recognizedText = "";
  late AudioPlayer audioPlayer;
  stt.SpeechToText speech = stt.SpeechToText();

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();

    if (widget.note != null) {
      final data = widget.note!.data() as Map<String, dynamic>;
      _titleController.text = data['title'];
      _descriptionController.text = data['description'];
      isPinned = data['isPinned'] ?? false;
      updateLastChanges(data['lastMod']);
    } else {
      updateLastChanges(Timestamp.fromDate(DateTime.now()));
    }

    speech.initialize(onStatus: (status) {
      if (status == 'listening') {
        setState(() {
          isListening = true;
        });
      }
    });
  }

  void updateLastChanges(Timestamp? lastMod) {
    if (lastMod != null) {
      final lastModifiedDate = lastMod.toDate();
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));

      if (now.difference(lastModifiedDate).inMinutes <= 1) {
        lastChanges = "Edited: ${DateFormat('h:mm a').format(lastModifiedDate)}";
      } else if (lastModifiedDate.isAfter(yesterday)) {
        lastChanges = "Edited: ${DateFormat('h:mm a').format(lastModifiedDate)}";
      } else {
        lastChanges = "Edited: ${DateFormat('MMM dd').format(lastModifiedDate)}";
      }
    }
  }

  bool isListening = false;

  void startListening() {
    speech.listen(
      onResult: (result) {
        setState(() {
          recognizedText = result.recognizedWords;
        });
      },
      listenFor: const Duration(seconds: 30),
    );
    setState(() {
      isListening = true;
      recognizedText = "";
    });
  }

  void stopListening() {
    speech.stop();
    setState(() {
      isListening = false;
    });
  }

  Future<void> saveNoteToFirestore() async {
    final title = _titleController.text;
    final description = _descriptionController.text;
    final now = Timestamp.fromDate(DateTime.now());

    final noteData = {
      'title': title,
      'description': description,
      'isPinned': isPinned,
      'lastMod': now,
    };

    if (widget.note != null) {
      widget.note!.reference.update(noteData);
    } else {
      await _firestore.collection('notes').add(noteData);
    }
  }
  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    speech.stop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await saveNoteToFirestore();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black54),
          actions: [
            IconButton(
              icon: Icon(
                isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                color: Colors.black54,
              ),
              onPressed: () {
                setState(() {
                  isPinned = !isPinned;
                });
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.notification_add_outlined,
                color: Colors.black54,
              ),
              onPressed: () {},
            ),
            if (widget.note != null)
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.black54,
                ),
                onPressed: () {
                  if (widget.note != null) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          title: const Text(
                            "Delete Note?",
                            style: TextStyle(fontFamily: 'Helvetica', color: Colors.black),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Lottie.asset('assets/json/delete_animation.json'),
                              const Text(
                                "This note will be permanently deleted.",
                                style: TextStyle(fontFamily: 'Helvetica', color: Colors.black54),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                _firestore.collection('notes').doc(widget.note!.id).delete();
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Proceed",
                                style: TextStyle(fontFamily: 'Helvetica', color: Colors.black54),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(fontFamily: 'Helvetica', color: Colors.black54),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
          ],
        ),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextFormField(
                      controller: _titleController,
                      cursorColor: const Color(0XFFCC313D),
                      decoration: const InputDecoration(
                        hintText: "Title",
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(fontFamily: 'Helvetica', fontSize: 30, color: Color(0XFFCC313D)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextFormField(
                      controller: _descriptionController,
                      cursorColor: const Color(0XFFCC313D),
                      onChanged: (text) {
                        final now = Timestamp.fromDate(DateTime.now());
                        if (widget.note != null) {
                          _firestore.collection('notes').doc(widget.note!.id).update({
                            'lastMod': now,
                          });
                          updateLastChanges(now);
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: "Note",
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(fontSize: 20, fontFamily: 'Helvetica', color: Colors.black),
                    ),
                  ),
                  if (isListening)
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        recognizedText,
                        style: const TextStyle(fontSize: 20, fontFamily: 'Helvetica', color: Colors.black),
                      ),
                    ),
                ],
              ),
              Positioned(
                bottom: 16.0,
                left: 16.0,
                child: GestureDetector(
                  onTap: _openOptionsBottomSheet,
                  child: const Icon(
                    Icons.add_box_outlined,
                    color: Colors.black54,
                    size: 32.0,
                  ),
                ),
              ),
              Positioned(
                bottom: 16.0,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    lastChanges,
                    style: const TextStyle(
                      fontFamily: 'Helvetica',
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
              const Positioned(
                bottom: 16.0,
                right: 16.0,
                child: Icon(
                  Icons.more_vert,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openOptionsBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.black,
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera, color: Colors.white60),
                title: const Text('Take a Photo', style: TextStyle(color: Colors.white60, fontFamily: 'Helvetica')),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.image, color: Colors.white60),
                title: const Text('Add Image', style: TextStyle(color: Colors.white60, fontFamily: 'Helvetica')),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.create, color: Colors.white60),
                title: const Text('Drawing', style: TextStyle(color: Colors.white60, fontFamily: 'Helvetica')),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.mic, color: Colors.white60),
                title: const Text('Recording', style: TextStyle(color: Colors.white60, fontFamily: 'Helvetica')),
                onTap: () {
                  startListening();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
