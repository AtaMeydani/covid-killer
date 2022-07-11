import 'dart:math';

import 'package:flutter/material.dart';

import '../components/level_list_tile.dart';
import '../db/database_helper.dart';

class LevelsManager extends ChangeNotifier {
  DatabaseHelper dbHelper = DatabaseHelper.instance;

  int presentLevel = 1;
  late List<dynamic> lvlsStatus;
  List<Widget> levelListTiles = [];
  Map<int, int> levelStar = {};
  bool allDone = false;

  LevelsManager() {
    levelSetUp();
  }

  void levelSetUp() async {
    if (DatabaseHelper.currentLoggedInEmail != null) {
      lvlsStatus = await dbHelper.getUserLevels();
      int? maxLevel = await dbHelper.getNumOfLevels();
      presentLevel = min(lvlsStatus.length + 1, maxLevel!);
      var userLevels = await dbHelper.getUserLevels();
      levelStar.clear();
      for (var element in userLevels) {
        levelStar[element['levelNum']] = element['star'];
      }

      allDone = presentLevel == maxLevel ? true : false;
      notifyListeners();
    }
  }

  void incrementLevel(int star, int selectedLevel) async {
    if (selectedLevel <= presentLevel) {
      var userLevels = await dbHelper.getLevelFromUserLevels(selectedLevel);
      if (userLevels.isEmpty) {
        levelStar[selectedLevel] = star;
        dbHelper.insert(tableName: 'userLevels', record: {"email": DatabaseHelper.currentLoggedInEmail, "levelNum": selectedLevel, "star": star});
        presentLevel = selectedLevel + 1;
      } else {
        if (userLevels[0]['star'] < star) {
          levelStar[selectedLevel] = star;
          await dbHelper.updateUserLevels(selectedLevel, {'star': star});
        }
      }
    }

    int? maxLevel = await dbHelper.getNumOfLevels();
    allDone = presentLevel == maxLevel ? true : false;

    notifyListeners();
  }

  void updateLevelStatus() async {
    lvlsStatus = await dbHelper.getUserLevels();
    notifyListeners();
  }

  bool validateSelectedLevel(int levelNum) {
    return levelNum <= presentLevel;
  }

  void getLevelsFromDB() async {
    levelListTiles.clear();
    int? value = await dbHelper.getNumOfLevels();
    if (value != null) {
      for (int i = 1; i <= value; i++) {
        levelListTiles.add(LevelListTile(levelNo: i));
        notifyListeners();
      }
    }
  }
}
