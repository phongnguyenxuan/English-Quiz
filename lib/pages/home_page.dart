import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:english_quiz/database/Database.dart';
import 'package:english_quiz/model/categories.dart' as category;
import 'package:english_quiz/model/question.dart';
import 'package:english_quiz/pages/info_page.dart';
import 'package:english_quiz/pages/play_page.dart';
import 'package:english_quiz/utils/color.dart';
import 'package:english_quiz/utils/font.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/quiz.dart';
import '../utils/constant_value.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //
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
  //
  bool canTap = true;
  //check internet
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  @override
  void initState() {
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    quizList = List.from(Database().loadData('$quizDB$categoryID'));
    isLoading = List.generate(quizList.length, (index) => false);
    nameController.text = name;

    super.initState();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    nameController.dispose();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (_) {
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  Future<dynamic> errorDialog(BuildContext context, Quiz quiz) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text("No connection"),
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    if (_connectionStatus.name == "none") {
                      errorDialog(context, quiz);
                    } else {
                      return;
                    }
                  },
                  child: const Text("Retry"))
            ],
          );
        });
  }

  String title = 'Level 1';
  double value = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              left: 0,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width - 80,
              child: _sidebar(),
            ),
            _body(),
          ],
        ),
      ),
    );
  }

  Widget _sidebar() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 80,
      height: double.infinity,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kDarkBlue,
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
                              decoration: InputDecoration(
                                counterText: null,
                                errorText:
                                    isEmpty ? "name can't be blank" : null,
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1)),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1)),
                                errorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1)),
                                focusedErrorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1)),
                              ),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(color: kPrimaryColor),
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
        body: Stack(
          children: [
            //image background
            Image.asset(
              'assets/images/drawer_background.png',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: categoryList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    setState(() {
                      value == 0 ? value = 1 : value = 0;
                      title = categoryList.elementAt(index).name;
                      categoryID = categoryList.elementAt(index).id;
                      quizList =
                          List.from(Database().loadData('$quizDB$categoryID'));
                      isLoading =
                          List.generate(quizList.length, (index) => false);
                    });
                  },
                  leading: const Icon(
                    Icons.library_books_rounded,
                    color: Colors.white,
                  ),
                  title: Text(
                    categoryList.elementAt(index).name,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: const TextStyle(
                        color: Colors.white, fontSize: bodyFontSize),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    var route = ModalRoute.of(context);
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 200),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      left: value == 1 ? MediaQuery.of(context).size.width - 80 : 0,
      child: GestureDetector(
        onTap: value == 0
            ? null
            : () {
                setState(() {
                  value == 0 ? value = 1 : value = 0;
                });
              },
        child: AbsorbPointer(
          absorbing: value == 1 ? true : false,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: kPrimaryColor,
              title: Text(title),
              leading: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  setState(() {
                    value == 0 ? value = 1 : value = 0;
                  });
                },
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const InfoPage(),
                      ));
                    },
                    icon: const Icon(Icons.info))
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: quizList.length,
                itemBuilder: (context, index) {
                  Quiz quiz = quizList.elementAt(index);
                  return ListTile(
                      onTap: (Database().loadData('$questionsDB${quiz.id}') !=
                              null)
                          ? () {
                              questionsList = List.from(Database()
                                  .loadData('$questionsDB${quiz.id}'));
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    settings: const RouteSettings(
                                      name: "playpage",
                                    ),
                                    builder: (context) => PlayPage(
                                          quiz: quiz,
                                          listQuestions: questionsList,
                                        )),
                              );
                            }
                          : null,
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
                      trailing: Database().loadData('$questionsDB${quiz.id}') ==
                              null
                          ? !isLoading[index]
                              ? IconButton(
                                  onPressed: canTap
                                      ? () async {
                                          try {
                                            if (_connectionStatus.name ==
                                                "none") {
                                              errorDialog(context, quiz);
                                            } else {
                                              setState(() {
                                                canTap = !canTap;
                                                isLoading[index] =
                                                    !isLoading[index];
                                              });

                                              await Database()
                                                  .getQuestionsByQuizId(
                                                      quiz.id);

                                              setState(() {
                                                canTap = !canTap;
                                                questionsList = Database()
                                                    .loadData(
                                                        '$questionsDB${quiz.id}');
                                              });
                                              if (route!.settings.name ==
                                                      "/homepage" &&
                                                  context.mounted) {
                                                Navigator.of(context)
                                                    .pushAndRemoveUntil(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              PlayPage(
                                                            quiz: quiz,
                                                            listQuestions:
                                                                questionsList,
                                                          ),
                                                        ),
                                                        ModalRoute.withName(
                                                            "/homepage"));
                                              } else {
                                                return;
                                              }
                                            }
                                          } catch (_) {}
                                        }
                                      : null,
                                  icon: const Icon(
                                    Icons.download,
                                    color: Colors.grey,
                                  ))
                              : const SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.grey,
                                    ),
                                  ))
                          : Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                  '${Database().loadData('$scoreDB${quiz.id}')}/${Database().loadData('count${quiz.id}').toString()}'),
                            ));
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
