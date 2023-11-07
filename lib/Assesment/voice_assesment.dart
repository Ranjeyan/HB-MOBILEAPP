import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:healingbee/Assesment/question_assesment.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:tflite_flutter/tflite_flutter.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: VoiceAssessment(key: GlobalKey(), title: "Voice Assessment"),
  ));
}

class VoiceAssessment extends StatefulWidget {
  const VoiceAssessment({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _VoiceAssessmentState createState() => _VoiceAssessmentState();
}

enum RecordingStatus {
  idle,
  counting,
  recording,
  recorded,
  paused,
}

class _VoiceAssessmentState extends State<VoiceAssessment> {
  FlutterSoundRecorder? _recordingSession;
  FlutterSoundPlayer? _player;
  RecordingStatus _recordingStatus = RecordingStatus.idle;
  Duration _recordedDuration = Duration.zero;
  Timer? _timer;
  String? _filePath;
  bool _audioSaved = false;
  int? _audioSize;
  bool _isPlaying = false;
  bool _isPaused = false;

  late Interpreter interpreter;


  @override
  void initState() {
    super.initState();
    _recordingSession = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();
    initializeAudioSessions();
    initializer();
    loadModel();
  }

  void loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset('assets/model.tflite');
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  List<List<List<double>>?>? preprocessAudioData(String filePath) {
    // Implement audio data preprocessing
    // Ensure the format of audio data matches the model's input requirements
    // Return the preprocessed data as a 3D list
    // Your preprocessing logic here

    // Replace with your preprocessing logic and return a non-null value.
    return /* Preprocessed data */ null;
  }

  Map<String, int?>? extractScores(List<List<List<double>>?> outputData) {
    // Implement logic to extract scores from model output
    // Your extraction logic here

    // Replace with your extraction logic and return a non-null value.
    return /* Extracted scores */ null;
  }


  void predictScores(String filePath) async {
    if (interpreter == null) {
      print("Model not loaded.");
      return;
    }

    final audioData = preprocessAudioData(filePath);

    try {
      final outputData = List.filled(1, [0, 0]);

      interpreter.run(audioData as Object, outputData);

      final scores = extractScores(outputData.cast<List<List<double>>>());

      print("Predicted PHQ Score: ${scores?['phq']}");
      print("Predicted GAD-7 Score: ${scores?['gad7']}");
    } catch (e) {
      print("Error during inference: $e");
    }
  }


  void initializeAudioSessions() async {
    await _player!.openAudioSession();
  }

  void closeAudioSessions() {
    _player!.closeAudioSession();
    _recordingSession!.closeAudioSession();
  }

  void initializer() async {
    await Permission.microphone.request();
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: Text(widget.title),
      ),
      body: Align(
        alignment: Alignment.bottomCenter,
        child: ListView(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Read and Record the Following Passage",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Helvetica',
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "The sun shone brightly on the calm lake, casting a warm golden glow. Birds chirped melodiously in the trees, their songs filling the air with joy. The wind whispered through the leaves, creating a gentle rustling sound. The waves lapped against the shore, creating a soothing rhythm. In the distance, children's laughter echoed, adding a touch of merriment to the scene. The peaceful tranquility of nature enveloped everything, bringing a sense of serenity to all who beheld it.",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontFamily: 'Lora',
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(height: 250),
            if (_recordingStatus == RecordingStatus.idle)
              Center(
                child: Column(
                  children: [
                    ClipOval(
                      child: Material(
                        color: Colors.black,
                        child: InkWell(
                          child: const SizedBox(
                            width: 56,
                            height: 56,
                            child: Icon(
                              Icons.mic,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            startCountdown();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Tap to record",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black26,
                        fontFamily: 'Helvetica',
                      ),
                    ),
                  ],
                ),
              ),
            if (_recordingStatus == RecordingStatus.counting)
              Center(
                child: Text(
                  "Recording in ${3 - _recordedDuration.inSeconds}...",
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black54,
                      fontFamily: 'Lora'
                  ),
                ),
              ),
            const SizedBox(height: 20,),
            if (_recordingStatus == RecordingStatus.recording || _recordingStatus == RecordingStatus.paused)
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: Material(
                        color: Colors.black,
                        child: InkWell(
                          child: SizedBox(
                            width: 56,
                            height: 56,
                            child: Icon(
                              _isPaused ? Icons.play_arrow : Icons.pause,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            if (_isPaused) {
                              resumeRecording();
                            } else {
                              pauseRecording();
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ClipOval(
                      child: Material(
                        color: Colors.black,
                        child: InkWell(
                          child: const SizedBox(
                            width: 56,
                            height: 56,
                            child: Icon(
                              Icons.stop,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            stopRecording();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),


            if (_recordingStatus == RecordingStatus.counting)
              Center(
                child: ClipOval(
                  child: Material(
                    color: Colors.black,
                    child: InkWell(
                      child: const SizedBox(
                        width: 56,
                        height: 56,
                        child: Icon(
                          Icons.cancel,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        cancelCountdown();
                      },
                    ),
                  ),
                ),
              ),
            if (_recordingStatus == RecordingStatus.recorded)
              Center(
                child: ClipOval(
                  child: Material(
                    color: Colors.black,
                    child: InkWell(
                      child: SizedBox(
                        width: 56,
                        height: 56,
                        child: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        if (_isPlaying) {
                          pauseAudio();
                        } else {
                          playAudio();
                        }
                      },
                    ),
                  ),
                ),
              ),
            if (_recordingStatus == RecordingStatus.recorded)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        child: const SizedBox(
                          width: 56,
                          height: 56,
                          child: Icon(
                            Icons.save,
                            color: Colors.black,
                          ),
                        ),
                        onTap: () {
                          saveAudio();
                        },
                      ),
                    ),
                  ),
                  ClipOval(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        child: const SizedBox(
                          width: 56,
                          height: 56,
                          child: Icon(
                            Icons.cancel,
                            color: Colors.black,
                          ),
                        ),
                        onTap: () {
                          cancelRecording();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            if (_audioSaved)
              Center(
                child: Column(
                  children: [
                    Text(
                      'Audio File Size: ${(_audioSize! / 1024).toStringAsFixed(2)} KB',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontFamily: 'Helvetica',
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
                      ),
                      onPressed: () async {
                        // Create an instance of ProgressDialog
                        ProgressDialog progressDialog = ProgressDialog(context);
                        progressDialog.style(
                          message: 'Processing...',
                          messageTextStyle: const TextStyle(
                            fontFamily: 'Lora', // Change to your desired font family
                            fontSize: 16, // Adjust the font size
                          ),
                          progressWidget: Container(
                            padding: EdgeInsets.all(16), // Adjust padding to change size
                            child: const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.black), // Change the color
                              strokeWidth: 2, // Adjust the line thickness
                            ),
                          ),
                        );

                        // Show the loading dialog
                        progressDialog.show();

                        // Delay for 3 seconds.
                        await Future.delayed(const Duration(seconds: 3));

                        // Hide the loading dialog
                        progressDialog.hide();

                        // Now, navigate to the questions assessment screen.
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuestionAssessment(),
                          ),
                        );
                      },
                      child: const Text(
                        'Proceed',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    )




                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }



  String formatDuration(Duration duration) {
    final int hours = duration.inHours;
    final int minutes = duration.inMinutes.remainder(60);
    final int seconds = duration.inSeconds.remainder(60);
    return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void startCountdown() async {
    setState(() {
      _recordingStatus = RecordingStatus.counting;
      _recordedDuration = Duration.zero;
      _filePath = null;
    });

    int countdown = 3;

    while (countdown > 0) {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        countdown--;
      });
    }

    startRecording();
  }




  void cancelCountdown() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }

    setState(() {
      _recordingStatus = RecordingStatus.idle;
      _recordedDuration = Duration.zero;
    });
  }

  void startRecording() async {
    if (_recordingStatus == RecordingStatus.recording) {
      stopRecording();
    }

    final appDir = await getApplicationDocumentsDirectory();
    final audioPath = '${appDir.path}/your_audio_file.wav';

    setState(() {
      _recordingStatus = RecordingStatus.recording;
      _filePath = audioPath;
      _recordedDuration = Duration.zero;
    });

    await _recordingSession!.openAudioSession();
    await _recordingSession!.startRecorder(
      toFile: audioPath,
      codec: Codec.pcm16WAV,
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_recordingStatus != RecordingStatus.recording) {
          timer.cancel();
        } else {
          _recordedDuration += const Duration(seconds: 1);
        }
      });
    });
  }

  void pauseRecording() {
    if (_recordingStatus == RecordingStatus.recording) {
      _recordingSession!.pauseRecorder();
      setState(() {
        _recordingStatus = RecordingStatus.paused;
        _isPaused = true;
      });
    }
  }

  void resumeRecording() {
    if (_recordingStatus == RecordingStatus.paused) {
      _recordingSession!.resumeRecorder();
      setState(() {
        _recordingStatus = RecordingStatus.recording;
        _isPaused = false;
      });
    }
  }

  void stopRecording() async {
    await _recordingSession!.stopRecorder();
    _timer?.cancel();
    setState(() {
      _recordingStatus = RecordingStatus.recorded;
      _isPlaying = false;
      _isPaused = false;
    });
  }

  void playAudio() async {
    if (_filePath != null) {
      _player!.startPlayer(
        fromURI: _filePath,
        codec: Codec.pcm16WAV,
        whenFinished: () {
          setState(() {
            _isPlaying = false;
          });
        },
      );
      setState(() {
        _isPlaying = true;
      });
    }
  }

  void pauseAudio() {
    if (_player!.isPlaying) {
      _player!.pausePlayer();
      setState(() {
        _isPlaying = false;
      });
    }
  }

  void cancelRecording() async {
    if (_player!.isPlaying) {
      _player!.stopPlayer();
    }

    if (_recordingStatus == RecordingStatus.recorded) {
      final File audioFile = File(_filePath!);
      if (await audioFile.exists()) {
        await audioFile.delete(); // Delete the recorded audio file
      }
    }

    setState(() {
      _recordingStatus = RecordingStatus.idle;
      _recordedDuration = Duration.zero;
      _filePath = null;
      _isPlaying = false;
    });
  }


  void saveAudio() async {
    if (_filePath != null) {
      final File audioFile = File(_filePath!);

      if (await audioFile.exists()) {
        final int audioSize = await audioFile.length();

        final FirebaseStorage storage = FirebaseStorage.instance;

        try {
          final Reference audioRef = storage.ref().child('audio').child('audio.wav');

          await audioRef.putFile(audioFile);

          setState(() {
            _audioSaved = true;
            _audioSize = audioSize;
          });

          // Now, navigate to the questions assessment screen


        } catch (e) {
          print('Error uploading audio: $e');
        }
      } else {
        print('Audio file does not exist.');
      }
    }
  }



  @override
  void dispose() {
    _recordingSession!.closeAudioSession();
    closeAudioSessions();
    super.dispose();
  }
}
