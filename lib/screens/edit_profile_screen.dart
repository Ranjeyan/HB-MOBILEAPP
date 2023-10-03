import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final String userName;
  final String userDob;
  final String userProfileImage;
  final String userEmail;

  EditProfileScreen({
    required this.userName,
    required this.userDob,
    required this.userProfileImage,
    required this.userEmail,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  DateTime? _selectedDate;
  String _selectedGender = '';
  FocusNode _nameFocusNode = FocusNode();
  bool _showCursor = true;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.userName;
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    super.dispose();
  }

  void _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {});
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
      });
    }
  }

  void _showGenderSelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                title: Text('Male'),
                onTap: () {
                  setState(() {
                    _selectedGender = 'Male';
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Female'),
                onTap: () {
                  setState(() {
                    _selectedGender = 'Female';
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Other'),
                onTap: () {
                  setState(() {
                    _selectedGender = 'Other';
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
      appBar: AppBar(
        backgroundColor: Color(0XFF024022),
        elevation: 0,
        title: Text('Edit Profile'),
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
                              title: Text('Camera'),
                              onTap: () {
                                _getImage(ImageSource.camera);
                                Navigator.of(context).pop();
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.photo),
                              title: Text('Gallery'),
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
                        child: Image.asset(
                          widget.userProfileImage,
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
                            color: Color(0XFF024022),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.white,
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
                                          title: Text('Camera'),
                                          onTap: () {
                                            _getImage(ImageSource.camera);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.photo),
                                          title: Text('Gallery'),
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
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Color(0XFF024022), fontFamily: 'Poppins'),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFF024022)),
                  ),
                ),
                showCursor: _showCursor,
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
                decoration: InputDecoration(
                  labelText: 'Gender',
                  labelStyle: TextStyle(color: Color(0XFF024022), fontFamily: 'Poppins'),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFF024022)),
                  ),
                  hintText: 'Select Gender',
                ),
                controller: TextEditingController(
                  text: _selectedGender,
                ),
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
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                  labelStyle: TextStyle(color: Color(0XFF024022), fontFamily: 'Poppins'),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFF024022)),
                  ),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                controller: TextEditingController(
                  text: _selectedDate != null
                      ? "${_selectedDate!.toLocal()}".split(' ')[0]
                      : '',
                ),
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
                    Navigator.pushNamed(context, '/profile');
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color(0XFF024022)),
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
                  style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
