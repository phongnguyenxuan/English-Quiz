import 'dart:io';

import 'package:english_quiz/database/Database.dart';
import 'package:english_quiz/model/categories.dart' as category;
import 'package:english_quiz/model/question.dart';
import 'package:english_quiz/pages/info_page.dart';
import 'package:english_quiz/pages/play_page.dart';
import 'package:english_quiz/services/api_services.dart';
import 'package:english_quiz/utils/color.dart';
import 'package:english_quiz/utils/font.dart';
import 'package:flutter/material.dart';
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
      List.from(Database().loadData(categoryDB));
  //
  List<Quiz> quizList = [];
  //
  List<Question> questionsList = [];
  //
  String name = Database().loadData(nameDB);
  //
  final TextEditingController nameController = TextEditingController();
  //
  bool isEmpty = false;
  //
  List<bool> isLoading = [];

  @override
  void initState() {
    quizList = List.from(Database().loadData('$quizDB$categoryID'));
    isLoading = List.generate(quizList.length, (index) => false);
    nameController.text = name;

    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
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
        Quiz quiz = quizList.elementAt(index);
        return ListTile(
            onTap: () {
              if (Database().loadData('$questionsDB${quiz.id}') != null) {
                questionsList =
                    List.from(Database().loadData('$questionsDB${quiz.id}'));
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PlayPage(
                          quiz: quiz,
                          listQuestions: questionsList,
                        )));
              } else {
                return;
              }
            },
            contentPadding: const EdgeInsets.all(8),
            leading: Container(
              width: 60,
              height: 60,
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
            title: Text(
              quizList.elementAt(index).name,
              style: const TextStyle(fontSize: bodyFontSize),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Database().loadData('$questionsDB${quiz.id}') == null
                ? !isLoading[index]
                    ? IconButton(
                        onPressed: () async {
                          setState(() {
                            isLoading[index] = !isLoading[index];
                          });
                          await Database().getQuestionsByQuizId(quiz.id);
                          setState(() {
                            questionsList =
                                Database().loadData('$questionsDB${quiz.id}');
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PlayPage(
                                      quiz: quiz,
                                      listQuestions: questionsList,
                                    )));
                          });
                        },
                        icon: const Icon(
                          Icons.download,
                          color: Colors.grey,
                        ))
                    : const SizedBox(
                        width: 20,
                        height: 20,
                        child: Center(
                            child: CircularProgressIndicator(
                          backgroundColor: Colors.grey,
                        )))
                : Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                        '${Database().loadData('$scoreDB${quiz.id}')}/${Database().loadData('count${quiz.id}').toString()}'),
                  ));
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
                title: Text(
                  name,
                  style: const TextStyle(color: Colors.white),
                ),
                actions: [
                  IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (BuildContext context, setS) {
                                return AlertDialog(
                                  content: TextFormField(
                                    controller: nameController,
                                    maxLength: 20,
                                    onChanged: (value) {},
                                    decoration: InputDecoration(
                                      counterText: null,
                                      errorText: isEmpty
                                          ? "name can't be blank"
                                          : null,
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 1)),
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 1)),
                                      errorBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 1)),
                                      focusedErrorBorder:
                                          const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1)),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          'Cancel',
                                          style:
                                              TextStyle(color: kPrimaryColor),
                                        )),
                                    ElevatedButton(
                                      onPressed: () {
                                        setS(
                                          () {
                                            nameController.text.isEmpty
                                                ? isEmpty = true
                                                : isEmpty = false;
                                          },
                                        );
                                        if (nameController.text.isNotEmpty) {
                                          setState(() {
                                            name = nameController.text;
                                            Database().updateName(name);
                                          });
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      child: const Text(
                                        'Ok',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.edit))
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
                        quizList = List.from(
                            Database().loadData('$quizDB$categoryID'));
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
