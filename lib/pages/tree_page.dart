import 'package:english_quiz/database/categoryDatabase.dart';
import 'package:english_quiz/pages/home_page.dart';
import 'package:flutter/material.dart';

class TreePage extends StatefulWidget {
  const TreePage({super.key});

  @override
  State<TreePage> createState() => _TreePageState();
}

class _TreePageState extends State<TreePage> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    if (myBox.isEmpty) {
      await CategoryDatabase().createDefaultDB();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (myBox.isEmpty) {
      return Container(
        color: Colors.red,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return MyHomePage();
    }
  }
}
