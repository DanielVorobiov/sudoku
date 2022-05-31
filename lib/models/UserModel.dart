class UserModel {
  int? id;
  String? firstName;

  // String? lastName;
  String email;
  String? password;
  int? level;
  int? xp;

  UserModel(
      {this.id,
      this.firstName,
      required this.email,
      this.password,
      this.level,
      this.xp});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'],
        firstName: json['first_name'],
        email: json['email'],
        level: json['level'],
        xp: json['xp']);
  }

  Map toMap() => {
        'first_name': firstName,
        'email': email,
        'password': password,
      };
}
