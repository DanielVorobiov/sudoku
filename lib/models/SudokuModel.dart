class SudokuModel {
  int? id;

  // String? lastName;
  String? complexity;
  List<dynamic>? puzzle;
  String? createdOn;
  String? createdAt;

  SudokuModel(
      {this.id,
      required this.complexity,
      this.puzzle,
      this.createdOn,
      this.createdAt});

  factory SudokuModel.fromJson(Map<String, dynamic> json) {
    return SudokuModel(
        id: json['id'],
        complexity: json['complexity'],
        puzzle: json['puzzle'],
        createdOn: json['created_on'],
        createdAt: json['created_at']);
  }

// Map toMap() => {
//       'first_name': firstName,
//       'email': email,
//       'password': password,
//     };
}
