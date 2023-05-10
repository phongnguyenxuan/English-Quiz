import 'package:english_quiz/pages/home_page.dart';
import 'package:english_quiz/utils/color.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Theme.of(context).copyWith(
          colorScheme:
              Theme.of(context).colorScheme.copyWith(primary: kPrimaryColor)),
      home: const MyHomePage(),
    );
  }
}
