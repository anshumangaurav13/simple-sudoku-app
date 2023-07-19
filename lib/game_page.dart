import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sudoku_app/sudoku_controller.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  var sudokuController = Get.put(SudokuController(Get.parameters));
  var _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
        const Duration(seconds: 1), (timer) => sudokuController.tick());
  }

  @override
  void dispose() {
    _timer.cancel();
    sudokuController.saveState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: const Center(child: Text("Game")),
          ),
      body: Column(
        children: [
          Obx(() => Text(
                sudokuController.getTime(),
                style:
                    const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              )),
          const SizedBox(height: 32),
          Center(
            child: Container(
              margin: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                    9,
                    (i) => Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            9,
                            (j) => Padding(
                                padding: const EdgeInsets.all(5),
                                child: !sudokuController.isEmpty(i, j)
                                    ? staticTile(i, j)
                                    : Obx(() => dynamicTile(i, j))),
                          ),
                        )),
              ),
            ),
          ),
          keyPad()
        ],
      ),
    );
  }

  Card keyPad() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: List.generate(
              3,
              (i) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      3,
                      (j) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                          onPressed: () {
                            var num = 3 * i + j + 1;
                            sudokuController.insertNumber(num);
                          },
                          child: Text(
                            "${3 * i + j + 1}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
        ),
      ),
    );
  }

  Widget staticTile(int i, int j) {
    var num = sudokuController.userBoard[i][j];
    bool temp = (3 * (i ~/ 3) + (j ~/ 3)) % 2 == 0;
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
              offset: const Offset(0, 0),
              color: temp ? Colors.deepOrange : Colors.deepPurple,
              blurRadius: 2)
        ],
      ),
      child: Center(
        child: Text(
          num.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Widget dynamicTile(int i, int j) {
    var num = sudokuController.userBoard[i][j];
    bool temp = (3 * (i ~/ 3) + (j ~/ 3)) % 2 == 0;
    return GestureDetector(
      onTap: () => sudokuController.setSelected(i, j),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 0),
                color: sudokuController.hasWon()
                    ? Colors.green
                    : (sudokuController.isSelected(i, j)
                        ? Colors.greenAccent
                        : temp
                            ? Colors.deepOrange
                            : Colors.deepPurple),
                blurRadius: 2)
          ],
        ),
        child: Center(
          child: Text(
            (num == 0 ? "" : num).toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
