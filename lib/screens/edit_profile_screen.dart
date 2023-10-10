import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EditProfileScreen(
        userName: 'Ran',
        userDob: '1990-01-01',
        userProfileImage: '',
        userEmail: 'ranje@example.com',
        userGender: 'Male',
        onSave: (name, gender, dob, profileImage) {},
      ),
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  final String userName;
  final String userDob;
  final String userProfileImage;
  final String userEmail;
  final String userGender;
  final Function(String, String, String, String) onSave;

  EditProfileScreen({
    required this.userName,
    required this.userDob,
    required this.userProfileImage,
    required this.userEmail,
    required this.userGender,
    required this.onSave,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  DateTime? _selectedDate;
  String _selectedGender = '';
  bool _uploadingImage = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.userName;
    _genderController.text = widget.userGender;
    if (widget.userDob.isNotEmpty) {
      _selectedDate = DateTime.parse(widget.userDob);
      _dobController.text = "${_selectedDate!.toLocal()}".split(' ')[0];
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = "${_selectedDate!.toLocal()}".split(' ')[0];
      });
    }
  }

  void _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      await _uploadProfileImage(File(pickedFile.path));
    }
  }

  Future<void> _uploadProfileImage(File imageFile) async {
    setState(() {
      _uploadingImage = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return;
      }

      final firebase_storage.Reference storageRef =
      firebase_storage.FirebaseStorage.instance
          .ref()
          .child('profile_images/${user.uid}.jpg');

      final uploadTask = storageRef.putFile(imageFile);

      await uploadTask.whenComplete(() async {
        final imageUrl = await storageRef.getDownloadURL();
        if (imageUrl != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({
            'profileImage': imageUrl,
          });

          widget.onSave(
            _nameController.text,
            _selectedGender,
            _selectedDate != null ? "${_selectedDate!.toLocal()}".split(' ')[0] : '',
            imageUrl,
          );

          Navigator.pop(context);
        }
      });
    } catch (e) {
      print('Error uploading profile image: $e');
    } finally {
      setState(() {
        _uploadingImage = false;
      });
    }
  }

  void _showGenderSelectionSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Color(0XFF00463C),
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                title: Text(
                  'Male',
                  style: TextStyle(fontFamily: 'Helvetica', color: Color(0XFFD4AF37)),
                ),
                onTap: () {
                  setState(() {
                    _selectedGender = 'Male';
                    _genderController.text = 'Male';
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text(
                  'Female',
                  style: TextStyle(fontFamily: 'Helvetica', color: Color(0XFFD4AF37)),
                ),
                onTap: () {
                  setState(() {
                    _selectedGender = 'Female';
                    _genderController.text = 'Female';
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text(
                  'Other',
                  style: TextStyle(fontFamily: 'Helvetica', color: Color(0XFFD4AF37)),
                ),
                onTap: () {
                  setState(() {
                    _selectedGender = 'Other';
                    _genderController.text = 'Other';
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF00463C),
      appBar: AppBar(
        backgroundColor: Color(0XFF00463C),
        elevation: 0,
        title: Text('Edit Profile', style: TextStyle(fontFamily: 'Helvetica')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return SafeArea(
                        child: Wrap(
                          children: [
                            ListTile(
                              leading: Icon(Icons.camera),
                              title: Text('Camera',style: TextStyle(fontFamily: 'Helvetica')),
                              onTap: () {
                                _getImage(ImageSource.camera);
                                Navigator.of(context).pop();
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.photo),
                              title: Text('Gallery',style: TextStyle(fontFamily: 'Helvetica')),
                              onTap: () {
                                _getImage(ImageSource.gallery);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  width: 120,
                  child: Stack(
                    children: [
                      ClipOval(
                        child: widget.userProfileImage.isNotEmpty
                            ? Image.network(
                          widget.userProfileImage,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                            : Image.asset(
                          'assets/images/profile.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 60,
                        right: 10,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0XFFD4AF37),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Color(0XFF00463C),
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return SafeArea(
                                    child: Wrap(
                                      children: [
                                        ListTile(
                                          leading: Icon(Icons.camera),
                                          title: Text('Camera',style: TextStyle(fontFamily: 'Helvetica')),
                                          onTap: () {
                                            _getImage(ImageSource.camera);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.photo),
                                          title: Text('Gallery',style: TextStyle(fontFamily: 'Helvetica'),),
                                          onTap: () {
                                            _getImage(ImageSource.gallery);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                style: TextStyle(color: Color(0XFFD4AF37)),
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.white, fontFamily: 'Helvetica'),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFF024022)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                readOnly: true,
                onTap: () => _showGenderSelectionSheet(context),
                style: TextStyle(color: Color(0XFFD4AF37)),
                decoration: InputDecoration(
                  labelText: 'Gender',
                  labelStyle: TextStyle(color: Colors.white, fontFamily: 'Helvetica'),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFF024022)),
                  ),
                  hintText: 'Select Gender',
                  hintStyle: TextStyle(color: Color(0XFFD4AF37), fontFamily: 'Helvetica'),
                ),
                controller: _genderController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Gender is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                readOnly: true,
                onTap: () => _selectDate(context),
                style: TextStyle(color: Color(0XFFD4AF37)),
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                  labelStyle: TextStyle(color: Colors.white, fontFamily: 'Helvetica'),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFFD4AF37)),
                  ),
                  suffixIcon: Icon(Icons.calendar_today, color: Color(0XFFD4AF37)),
                ),
                controller: _dobController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Date of Birth is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 100),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.onSave(
                      _nameController.text,
                      _selectedGender,
                      _selectedDate != null ? "${_selectedDate!.toLocal()}".split(' ')[0] : '',
                      widget.userProfileImage,
                    );
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color(0XFFD4AF37)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  minimumSize: MaterialStateProperty.all<Size>(
                    Size(120.0, 50.0),
                  ),
                ),
                child: Text(
                  'Save',
                  style: TextStyle(color: Color(0XFF00463C), fontFamily: 'Helvetica', fontSize: 15),
                ),
              ),
              if (_uploadingImage)
                Padding(
                  padding: const EdgeInsets.only(top: 15.0), // Adjust the top value to move it down
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0XFFF06151)), // Change color here
                  ),
                )

            ],
          ),
        ),
      ),
    );
  }
}
