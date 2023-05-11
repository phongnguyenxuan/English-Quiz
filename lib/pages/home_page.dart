import 'dart:async';
import 'dart:convert';
import 'package:english_quiz/database/categoryDatabase.dart';
import 'package:english_quiz/model/categories.dart' as category;
import 'package:english_quiz/pages/info_page.dart';
import 'package:english_quiz/utils/color.dart';
import 'package:english_quiz/utils/font.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../model/quiz.dart';
import '../utils/constant_value.dart';
import '../widget/side_item.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //
  int categoryID = 3;
  List<category.Category> categoryList =
      List.from(CategoryDatabase().loadData(categoryDB));
  List<Quiz> quizList = [];
  final myBox = Hive.box('myBox');
  @override
  void initState() {
    quizList = List.from(CategoryDatabase().loadData('${quizDB}$categoryID'));
    super.initState();
  }

  String title = 'Level 1';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kbackgroundColor,
        appBar: AppBar(
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.info_rounded),
              onPressed: () {
                //push info page
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const InfoPage()));
              },
            ),
          ],
          title: Text(
            title,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: titleFontSize),
          ),
        ),
        body: _body(),
        drawer: sideBar(context),
      ),
    );
  }

  Widget _body() {
    return ListView.builder(
      itemCount: quizList.length,
      itemBuilder: (context, index) {
        return Container(
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.all(10),
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: kPrimaryColor,
                ),
                child: Center(
                  child: Text(
                    (index + 1).toString(),
                    style: const TextStyle(
                        fontSize: titleFontSize,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  quizList.elementAt(index).name,
                  style: const TextStyle(fontSize: bodyFontSize),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.download,
                    color: Colors.grey,
                  ))
            ],
          ),
        );
      },
    );
  }

  Drawer sideBar(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          //image background
          Image.asset(
            'assets/images/drawer_background.png',
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Column(
            children: [
              AppBar(
                leadingWidth: 50,
                //avatar
                leading: Container(
                  margin: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage('assets/images/icon.png'))),
                ),
                title: const Text(
                  "@name",
                  style: TextStyle(color: Colors.white),
                ),
                actions: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.edit))
                ],
              ),
              Expanded(
                  child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: categoryList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      setState(() {
                        title = categoryList.elementAt(index).name;
                        categoryID = categoryList.elementAt(index).id;
                        quizList = List.from(CategoryDatabase()
                            .loadData('${quizDB}$categoryID'));
                      });
                      Navigator.pop(context);
                    },
                    title: SideItem(title: categoryList.elementAt(index).name),
                  );
                },
              ))
            ],
          ),
        ],
      ),
    );
  }
}
