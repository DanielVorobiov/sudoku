class StatisticsModel {
  int gamesNumberEasy;
  int gamesNumberMedium;
  int gamesNumberHard;
  String bestTimeEasy;
  String bestTimeMedium;
  String bestTimeHard;
  int puzzleCreatedNumberEasy;
  int puzzleCreatedNumberMedium;
  int puzzleCreatedNumberHard;

  StatisticsModel(
      {required this.gamesNumberEasy,
      required this.gamesNumberMedium,
      required this.gamesNumberHard,
      required this.bestTimeEasy,
      required this.bestTimeMedium,
      required this.bestTimeHard,
      required this.puzzleCreatedNumberEasy,
      required this.puzzleCreatedNumberMedium,
      required this.puzzleCreatedNumberHard});

  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    return StatisticsModel(
      gamesNumberEasy: json['games_number_easy'],
      gamesNumberMedium: json['games_number_medium'],
      gamesNumberHard: json['games_number_hard'],
      bestTimeEasy: json['best_time_easy'],
      bestTimeMedium: json['best_time_medium'],
      bestTimeHard: json['best_time_hard'],
      puzzleCreatedNumberEasy: json['puzzle_created_number_easy'],
      puzzleCreatedNumberMedium: json['puzzle_created_number_medium'],
      puzzleCreatedNumberHard: json['puzzle_created_number_hard'],
    );
  }

// Map toMap() => {
//   'first_name': firstName,
//   'email': email,
//   'password': password,
// };
}
