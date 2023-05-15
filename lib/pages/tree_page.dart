import 'package:english_quiz/database/Database.dart';
import 'package:english_quiz/pages/home_page.dart';
import 'package:flutter/material.dart';

import '../utils/color.dart';

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
try{
  await Database().createDefaultDB();
  setState(() {});
}catch(e){
  print(e);
}
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    if (myBox.isEmpty) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: kbackgroundColor,
          body: SizedBox(
            width: size.width,
            height: size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.asset('assets/images/logo.png'),
                ),
                const SizedBox(width: 200, child: LinearProgressIndicator()),
              ],
            ),
          ),
        ),
      );
    } else {
      return const MyHomePage();
    }
  }
}
