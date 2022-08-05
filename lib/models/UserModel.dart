class UserModel {
  int? id;
  String? nickname;

  // String? lastName;
  String email;
  String? password;
  int? level;
  int? xp;

  UserModel(
      {this.id,
      this.nickname,
      required this.email,
      this.password,
      this.level,
      this.xp});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'],
        nickname: json['nickname'],
        email: json['email'],
        level: json['level'],
        xp: json['xp']);
  }

  Map toMap() => {
        'nickname': nickname,
        'email': email,
        'password': password,
      };
}
