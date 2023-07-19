import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sudoku_app/game_page.dart';
import 'package:sudoku_app/home_page.dart';

final lightTheme = ThemeData(
  useMaterial3: true,
  primarySwatch: Colors.blue,
  brightness: Brightness.light,
);

final darkTheme = ThemeData(
  useMaterial3: true,
  primarySwatch: Colors.deepPurple,
  brightness: Brightness.dark,
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme,
      // darkTheme: darkTheme,
      home: const HomePage(),
      getPages: [
        GetPage(name: '/', page: () => const HomePage()),
        GetPage(name: '/gamePage', page: () => const GamePage())
      ],
    );
  }
}
