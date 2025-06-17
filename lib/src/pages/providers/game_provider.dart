import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayerScore {
  final String name;
  final int score;

  PlayerScore(this.name, this.score);

  Map<String, dynamic> toJson() => {
        'name': name,
        'score': score,
      };

  factory PlayerScore.fromJson(Map<String, dynamic> json) {
    return PlayerScore(
      json['name'] as String,
      json['score'] as int,
    );
  }
}

class GameProvider extends ChangeNotifier {
  List<int> listNumber = [];
  List<int> selectedNumbers = [];
  int nextNumber = 1;
  int score = 0;
  int timeLeft = 200;
  bool isGameOver = false;
  List<PlayerScore> playerScores = [];

  GameProvider() {
    resetGame();
    loadScores();
  }

  String get formattedTime => timeLeft.toString().padLeft(2, '0');

  void resetGame() {
    listNumber = List.generate(50, (index) => index + 1)..shuffle();
    selectedNumbers.clear();
    nextNumber = 1;
    score = 0;
    timeLeft = 200;
    isGameOver = false;
    notifyListeners();
  }

  void decrementTime() {
    if (timeLeft > 0) {
      timeLeft--;
      notifyListeners();
    }
    if (timeLeft == 0) {
      isGameOver = true;
      notifyListeners();
    }
  }

  bool tapNumber(int number) {
    if (number == nextNumber) {
      selectedNumbers.add(number);
      nextNumber++;
      score += 1;
      if (nextNumber > 50) {
        isGameOver = true;
      }
      notifyListeners();
      return true;
    }
    isGameOver = true;
    notifyListeners();
    return false;
  }

  Future<void> loadScores() async {
    final prefs = await SharedPreferences.getInstance();
    final scoreList = prefs.getStringList('playerScores') ?? [];
    playerScores = scoreList.map((scoreJson) {
      final Map<String, dynamic> scoreMap = Map<String, dynamic>.from(
          Map.fromEntries(scoreJson.split('&').map((e) {
        final parts = e.split('=');
        return MapEntry(parts[0], parts[1]);
      })));
      return PlayerScore.fromJson(scoreMap);
    }).toList();
    notifyListeners();
  }

  Future<void> savePlayerScore(String name) async {
    if (name.isEmpty) name = 'Player';
    playerScores.add(PlayerScore(name, score));
    playerScores.sort((a, b) => b.score.compareTo(a.score));
    final prefs = await SharedPreferences.getInstance();
    final scoreList = playerScores.map((score) {
      return 'name=${score.name}&score=${score.score}';
    }).toList();
    await prefs.setStringList('playerScores', scoreList);
    notifyListeners();
  }

  Future<void> clearScores() async {
    playerScores.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('playerScores');
    notifyListeners();
  }
}