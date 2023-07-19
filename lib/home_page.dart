import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(child: Text("Sudoku")),
            // InkWell(
            //   onTap: () {
            //     //TODO: implement code for changing theme
            //   },
            //   child: const Icon(Icons.dark_mode),
            // ),
          ],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            optionCard(
              "Continue",
              "Continue the previous game of Sudoku.",
              onTap: () async {
                var prefs = await SharedPreferences.getInstance();
                var val = prefs.getInt('secondsPassed');
                if (val == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("No old game found.")),
                  );
                } else {
                  Get.toNamed('/gamePage', parameters: {'game': 'old'});
                }
              },
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ExpansionTile(
                title: const ListTile(
                  title: Text("New Game",
                      style: TextStyle(
                        fontSize: 24,
                      )),
                  subtitle: Text("Start a new game of Sudoku."),
                ),
                children: [
                  diffTile('Hard', '54'),
                  diffTile('Medium', '36'),
                  diffTile('Easy', '27'),
                  diffTile('Beginner', '18'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListTile diffTile(String diff, String diffNum) {
    return ListTile(
        onTap: () {
          Get.toNamed('/gamePage',
              parameters: {'difficulty': diffNum, 'game': 'new'});
        },
        title: Center(child: Text(diff)));
  }

  Widget optionCard(String title, String subTitle,
      {required void Function()? onTap}) {
    return ListTile(
      onTap: onTap,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(title,
            style: const TextStyle(
              fontSize: 24,
            )),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(subTitle),
      ),
    );
  }
}
