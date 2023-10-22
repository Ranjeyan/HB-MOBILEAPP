import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../widgets/edit_item.dart';

class EditAccountScreen extends StatefulWidget {
  const EditAccountScreen({Key? key}) : super(key: key);

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  String gender = "man";
  String userName = '';
  String userEmail = '';
  String? newProfileImage;

  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false; // Added for tracking upload state

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (userSnapshot.exists) {
        setState(() {
          userName = userSnapshot.get('name') ?? '';
          userEmail = userSnapshot.get('email') ?? '';
          newProfileImage = userSnapshot.get('profileImage');
        });
      }
    }
  }

  Future<void> _uploadImage() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;

    setState(() {
      _isUploading = true; // Start the upload and show the loader
    });

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('profile_images')
        .child(DateTime.now().toString() + '.jpg');

    final UploadTask uploadTask = storageRef.putFile(File(pickedImage.path));
    final TaskSnapshot downloadUrl = await uploadTask;

    final String imageUrl = await downloadUrl.ref.getDownloadURL();

    setState(() {
      newProfileImage = imageUrl;
      _isUploading = false; // Upload finished, hide the loader
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, newProfileImage);
          },
          icon: const Icon(
            Ionicons.chevron_back_outline,
            color: Colors.black54,
          ),
        ),
        leadingWidth: 80,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                _saveData();
              },
              style: IconButton.styleFrom(
                backgroundColor: Colors.black54,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                fixedSize: const Size(60, 50),
                elevation: 3,
              ),
              icon: const Icon(Ionicons.checkmark, color: Colors.black54),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Account",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Helvetica'
                ),
              ),
              const SizedBox(height: 50),
              EditItem(
                title: "Photo",
                widget: Column(
                  children: [
                    ClipOval(
                      child: newProfileImage != null
                          ? Image.network(
                        newProfileImage!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                          : Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black45,
                        ),
                        child: Center(
                          child: Text(
                            userName.isNotEmpty ? userName[0] : "U",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    _isUploading
                        ? const CircularProgressIndicator() // Show loader while uploading
                        : TextButton(
                      onPressed: _uploadImage,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.lightBlueAccent,
                      ),
                      child: const Text(
                        "Upload Image",
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              EditItem(
                title: "Name",
                widget: TextField(
                  controller: TextEditingController(text: userName),
                ),
              ),
              EditItem(
                title: "Gender",
                widget: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          gender = "man";
                        });
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: gender == "man" ? Colors.deepPurple : Colors.grey.shade200,
                        fixedSize: const Size(50, 50),
                      ),
                      icon: Icon(
                        Ionicons.male,
                        color: gender == "man" ? Colors.white : Colors.black,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          gender = "woman";
                        });
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: gender == "woman" ? Colors.deepPurple : Colors.grey.shade200,
                        fixedSize: const Size(50, 50),
                      ),
                      icon: Icon(
                        Ionicons.female,
                        color: gender == "woman" ? Colors.white : Colors.black,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const EditItem(
                widget: TextField(),
                title: "Age",
              ),
              const EditItem(
                widget: TextField(),
                title: "Email",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
        await userRef.set({
          'name': userName,
          'email': userEmail,
          'gender': gender,
          'profileImage': newProfileImage,
        });

        Navigator.pop(context);
      } catch (error) {
        print('Error updating user data: $error');
      }
    }
  }
}
