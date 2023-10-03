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
