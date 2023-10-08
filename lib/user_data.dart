// user_data_provider.dart

import 'package:flutter/foundation.dart';

class UserData {
  String name;
  String gender;
  DateTime? dateOfBirth;

  UserData({
    required this.name,
    required this.gender,
    this.dateOfBirth,
  });
}

class UserDataProvider extends ChangeNotifier {
  final UserData _userData = UserData(name: '', gender: '', dateOfBirth: null);

  UserData get userData => _userData;

  void updateName(String name) {
    _userData.name = name;
    notifyListeners();
  }

  void updateGender(String gender) {
    _userData.gender = gender;
    notifyListeners();
  }

  void updateDateOfBirth(DateTime? dateOfBirth) {
    _userData.dateOfBirth = dateOfBirth;
    notifyListeners();
  }
}
