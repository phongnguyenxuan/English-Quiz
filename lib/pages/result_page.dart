// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:english_quiz/utils/constant_value.dart';
import 'package:flutter/material.dart';

import 'package:english_quiz/database/Database.dart';
import 'package:english_quiz/model/answer.dart';
import 'package:english_quiz/model/question.dart';
import 'package:english_quiz/pages/home_page.dart';
import 'package:english_quiz/utils/color.dart';
import 'package:english_quiz/utils/font.dart';

class ResultPage extends StatefulWidget {
  List<Question> listQuestions;
  int quizID;
  ResultPage({
    Key? key,
    required this.listQuestions,
    required this.quizID,
  }) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  List<int> correctAnswer = [];
  List<int> wrongAnswer = [];
  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.listQuestions.length; i++) {
      Answer? answerChoice =
          Database().loadData(widget.listQuestions.elementAt(i).id.toString());
      if (answerChoice != null) {
        if (answerChoice.correct == 1) {
          correctAnswer.add(answerChoice.id);
        } else {
          wrongAnswer.add(answerChoice.id);
        }
      } else {
        wrongAnswer.add(0);
      }
    }
    //update high score
    int score = correctAnswer.length;
    int highScore = Database().loadData('$scoreDB${widget.quizID}');
    if (score > highScore) {
      Database().updateHighScore(widget.quizID, score);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.canPop(context)) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const MyHomePage()),
              (route) => false);
        }
        return true;
      },
      child: SafeArea(
        child: Scaffold(
            backgroundColor: kbackgroundColor,
            appBar: AppBar(
              centerTitle: true,
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const MyHomePage()));
                  },
                  icon: const Icon(Icons.home)),
              title: const Text(
                'RESULT TEST',
                style: TextStyle(color: Colors.white, fontSize: titleFontSize),
              ),
              actions: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.share))
              ],
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'You finished the lesson with',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  //
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.greenAccent.shade400,
                            shape: BoxShape.circle),
                        child: Center(
                          child: Text(
                            correctAnswer.length.toString(),
                            style: const TextStyle(
                                fontSize: titleFontSize, color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 60,
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.redAccent.shade400,
                            shape: BoxShape.circle),
                        child: Center(
                          child: Text(
                            wrongAnswer.length.toString(),
                            style: const TextStyle(
                                fontSize: titleFontSize, color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: List<Widget>.generate(widget.listQuestions.length,
                        (index) {
                      Question question = widget.listQuestions.elementAt(index);
                      Answer? answerChoice = Database().loadData(
                          widget.listQuestions.elementAt(index).id.toString());
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Question
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              '${index + 1}. ${question.content}',
                              style: const TextStyle(fontSize: bodyFontSize),
                            ),
                          ),
                          Column(
                            children:
                                List.generate(question.answers.length, (index) {
                              Answer answer = question.answers.elementAt(index);
                              return SizedBox(
                                height: 70,
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.all(10),
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(90)),
                                        border: Border.all(
                                            width: 2,
                                            color: answerChoice != null
                                                ? answer.correct == 1
                                                    ? Colors
                                                        .greenAccent.shade400
                                                    : Colors.redAccent.shade400
                                                : answer.correct == 1
                                                    ? Colors
                                                        .greenAccent.shade400
                                                    : Colors.grey),
                                      ),
                                      child: Center(
                                        child: Text(
                                          answer.content,
                                          style: const TextStyle(
                                              fontSize: bodyFontSize),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 25,
                                      bottom: 45,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            color: kbackgroundColor,
                                            shape: BoxShape.circle),
                                        child: answerChoice != null
                                            ? answer.id == answerChoice.id
                                                ? Icon(
                                                    Icons.check_circle,
                                                    color:
                                                        answerChoice.correct ==
                                                                1
                                                            ? Colors.greenAccent
                                                                .shade400
                                                            : Colors.redAccent
                                                                .shade400,
                                                  )
                                                : null
                                            : null,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }),
                          ),

                          Center(
                            child: Container(
                              height: 2,
                              width: 100,
                              margin: const EdgeInsets.all(20),
                              color: Colors.grey,
                            ),
                          )
                        ],
                      );
                    }),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
