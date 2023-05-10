import 'dart:convert';
import 'package:english_quiz/model/categories.dart' as category;
import 'package:english_quiz/model/quiz.dart';
import 'package:english_quiz/pages/info_page.dart';
import 'package:english_quiz/services/api_services.dart';
import 'package:english_quiz/utils/color.dart';
import 'package:english_quiz/utils/font.dart';
import 'package:english_quiz/widget/side_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //get data
  List<category.Category> listCate = [];
  //
  List<Quiz> listQuiz = [];
  //
  int categoryID = 3;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {}

  getQuiz() async {
    listQuiz = await ApiService().getQuiz(categoryID);
    setState(() {});
  }

  String title = 'Level 1';
  @override
  Widget build(BuildContext context) {
    return listCate.isNotEmpty
        ? SafeArea(
            child: Scaffold(
              backgroundColor: kbackgroundColor,
              appBar: AppBar(
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.info_rounded),
                    onPressed: () {
                      //push info page
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const InfoPage()));
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
          )
        : const Center(child: CircularProgressIndicator());
  }

  Widget _body() {
    return ListView.builder(
      itemCount: listQuiz.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(),
          title: Text(listQuiz.elementAt(index).name),
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
                itemCount: listCate.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      setState(() {
                        title = listCate.elementAt(index).name;
                        categoryID = listCate.elementAt(index).id;
                        getQuiz();
                      });
                      Navigator.pop(context);
                    },
                    title: SideItem(title: listCate.elementAt(index).name),
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
