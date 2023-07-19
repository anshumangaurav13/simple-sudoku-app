import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_solver_generator/sudoku_solver_generator.dart';

String convert2DListToString(List<List> list) {
  String result = '';

  for (int i = 0; i < list.length; i++) {
    List sublist = list[i];
    for (int j = 0; j < sublist.length; j++) {
      result += sublist[j].toString();
      if (j < sublist.length - 1) {
        result += ' ';
      }
    }
    if (i < list.length - 1) {
      result += '\n';
    }
  }

  return result;
}

List<List<int>> convertStringTo2DList(String str) {
  List<List<int>> result = [];

  List<String> lines = str.split('\n');
  for (String line in lines) {
    List<String> values = line.split(' ');
    List<int> sublist = [];
    for (String value in values) {
      sublist.add(int.parse(value));
    }
    result.add(sublist);
  }

  return result;
}

class SudokuController extends GetxController {
  var _currentBoard = <List<int>>[];
  var _solvedBoard = <List<int>>[];
  var _emptySpaces = <List<bool>>[];

  var userBoard = <RxList<int>>[].obs;
  var _selectedTile = (-1).obs;
  var _secondsPassed = 0.obs;

  // var minutesPassed = 0.obs;

  void saveState() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setInt('secondsPassed', _secondsPassed.value);
    prefs.setInt('selectedTile', _selectedTile.value);

    prefs.setString('currentBoard', convert2DListToString(_currentBoard));
    prefs.setString('solvedBoard', convert2DListToString(_solvedBoard));
    prefs.setString('emptySpaces', convert2DListToString(_emptySpaces));
    prefs.setString('userBoard', convert2DListToString(userBoard));
  }

  Future<void> retrieveState() async {
    var prefs = await SharedPreferences.getInstance();
    _secondsPassed.value = prefs.getInt('secondsPassed')!;
    _selectedTile.value = prefs.getInt('secondsPassed')!;

    var tmp;
    tmp = prefs.getStringList('currentBoard');
    _currentBoard = tmp
        .map((row) => row.split(';;;').map(int.parse).toList())
        .toList() as List<List<int>>;
    tmp = prefs.getStringList('solvedBoard');
    _solvedBoard = tmp
        .map((row) => row.split(';;;').map(int.parse).toList())
        .toList() as List<List<int>>;
    tmp = prefs.getStringList('emptySpaces');
    _emptySpaces = tmp
        .map((row) => row.split(';;;').map(int.parse).toList())
        .toList() as List<List<bool>>;
    tmp = prefs.getStringList('userBoard');
    userBoard.value = tmp
        .map((row) => row.split(';;;').map(int.parse).toList())
        .toList() as List<RxList<int>>;
    print("$tmp");
  }

  SudokuController(parameters) {
    if (parameters['game'] == 'old') {
      retrieveState();
    } else if (parameters['game'] == 'new') {
      int diffNum = int.parse(parameters['difficulty']);
      _currentBoard = SudokuGenerator(emptySquares: diffNum).newSudoku;
      _solvedBoard = SudokuSolver.solve(_currentBoard);

      _emptySpaces = List.generate(9, (i) => List.generate(9, (j) => false));
      for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
          if (_currentBoard[i][j] == 0) {
            _emptySpaces[i][j] = true;
          }
        }
      }

      userBoard.value = List.generate(9, (i) => RxList.generate(9, (j) => 0));
      for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
          userBoard[i][j] = _currentBoard[i][j];
        }
      }
    }
  }

  bool isEmpty(int i, int j) {
    return _emptySpaces[i][j];
  }

  void setSelected(int i, int j) {
    _selectedTile.value = 9 * i + j;
  }

  bool isSelected(int i, int j) {
    return (9 * i + j) == _selectedTile;
  }

  void insertNumber(int n) {
    var i = _selectedTile.value ~/ 9, j = _selectedTile.value % 9;
    userBoard[i][j] = n;
  }

  bool hasWon() {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (userBoard[i][j] != _solvedBoard[i][j]) {
          return false;
        }
      }
    }
    return true;
  }

  void tick() {
    if (hasWon()) return;
    _secondsPassed.value++;
  }

  String getTime() {
    var s = _secondsPassed.value;
    var m = s ~/ 60;
    var ms = m < 10 ? "0$m" : m.toString();
    var ss = s < 10 ? "0$s" : s.toString();
    return "$ms:$ss";
  }
}
