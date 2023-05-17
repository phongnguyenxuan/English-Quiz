import 'dart:async';

import 'package:english_quiz/database/Database.dart';
import 'package:english_quiz/model/answer.dart';
import 'package:english_quiz/model/quiz.dart';
import 'package:english_quiz/pages/result_page.dart';
import 'package:english_quiz/utils/color.dart';
import 'package:flutter/material.dart';

import 'package:english_quiz/model/question.dart';

import '../utils/font.dart';

// ignore: must_be_immutable
class PlayPage extends StatefulWidget {
  Quiz quiz;
  List<Question> listQuestions;
  PlayPage({
    Key? key,
    required this.quiz,
    required this.listQuestions,
  }) : super(key: key);

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  int i = 0;
  //
  List<bool> isClick = [];
  //
  int timePlay = 0;
  //
  int left = 0;
  //
  int questionsLength = 0;
  //
  int right = 0;
  //
  @override
  void initState() {
    super.initState();
    //
    questionsLength = widget.listQuestions.length;
    right = questionsLength ~/ 2;
    //
    isClick = List.generate(
        widget.listQuestions.elementAt(i).answers.length, (index) => false);
    Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        timePlay = timer.tick;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Question question = widget.listQuestions.elementAt(i);
    return SafeArea(
      child: Scaffold(
          backgroundColor: kbackgroundColor,
          appBar: header(),
          body: Column(
            children: [
              //questions
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  question.content,
                  style: const TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.w500),
                ),
              ),
              answer(question),
              const Spacer(),
              footer(context, question)
            ],
          )),
    );
  }

  AppBar header() {
    return AppBar(
      centerTitle: true,
      title: Text(widget.quiz.name,
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: titleFontSize)),
      bottom: PreferredSize(
          preferredSize: const Size(0, 50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: List.generate(left > 6 ? 6 : left, (index) {
                      return Container(
                        height: 3,
                        width: 15,
                        margin: const EdgeInsets.all(5),
                        color: kLevelColor,
                      );
                    }),
                  ),
                ),
                Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: Center(
                      child: Text(
                    "${i + 1}",
                    style: const TextStyle(color: kPrimaryColor),
                  )),
                ),
                Expanded(
                  child: Row(
                    children: List.generate(
                        i + 1 < questionsLength ~/ 2
                            ? 6
                            : questionsLength - left - 1 > 6
                                ? 6
                                : questionsLength - left - 1, (index) {
                      return Container(
                        height: 3,
                        width: 15,
                        margin: const EdgeInsets.all(5),
                        color: kLevelColor,
                      );
                    }),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Row footer(BuildContext context, Question question) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: i == 0
              ? null
              : () {
                  if (i < questionsLength) {
                    setState(() {
                      i -= 1;
                    });
                    if (left < questionsLength) {
                      left--;
                      if (i <= questionsLength ~/ 2) {
                        right++;
                      }
                    }
                  }
                },
          child: Container(
            width: 150,
            height: 60,
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: kPrimaryColor),
                borderRadius: BorderRadius.circular(90)),
            child: Center(
              child: Text(
                'Prev',
                style: TextStyle(
                    fontSize: titleFontSize,
                    color: i == 0 ? Colors.grey : kPrimaryColor),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Database().updateAnswerByQuestions(question, null);
            nextQuestion(context);
          },
          child: Container(
            width: 150,
            height: 60,
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: kPrimaryColor,
                border: Border.all(color: kPrimaryColor),
                borderRadius: BorderRadius.circular(90)),
            child: Center(
              child: Text(
                (i >= widget.listQuestions.length - 1) ? "Finish" : "Next",
                style: const TextStyle(
                    fontSize: titleFontSize, color: Colors.white),
              ),
            ),
          ),
        )
      ],
    );
  }

  //nextQuestions
  void nextQuestion(BuildContext context) {
    if (i >= widget.listQuestions.length - 1) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'All questions are over in',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w600),
                  ),
                  Image.asset('assets/images/result-icon.png'),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ResultPage(
                                listQuestions: widget.listQuestions,
                                quiz: widget.quiz,
                                timePlay: timePlay,
                              )));
                    },
                    child: Container(
                      // width: 150,
                      height: 60,
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: kPrimaryColor,
                          border: Border.all(color: kPrimaryColor),
                          borderRadius: BorderRadius.circular(90)),
                      child: const Center(
                        child: Text(
                          'Check my answer',
                          style: TextStyle(
                              fontSize: titleFontSize, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      // width: 150,
                      height: 60,
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: kPrimaryColor),
                          borderRadius: BorderRadius.circular(90)),
                      child: const Center(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                              fontSize: titleFontSize, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      if (i <= questionsLength) {
        // print(left.length);
        setState(() {
          i += 1;
        });
        if (left < questionsLength) {
          left++;
          if (i >= questionsLength - left) {
            right--;
          }
        }
      }
    }
  }

  Column answer(Question question) {
    return Column(
        children: List<Widget>.generate(question.answers.length, (index) {
      Answer answer = question.answers.elementAt(index);
      return GestureDetector(
        onTap: () {
          setState(() {
            isClick[index] = !isClick[index];
          });
          Database().updateAnswerByQuestions(question, answer);
          Future.delayed(const Duration(milliseconds: 500), () {
            isClick[index] = !isClick[index];
            nextQuestion(context);
          });
        },
        child: Center(
          child: Container(
            height: 50,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                    color: isClick[index] ? kPrimaryColor : Colors.grey),
                borderRadius: BorderRadius.circular(90)),
            child: Center(
                child: Text(
              answer.content,
              style: const TextStyle(fontSize: bodyFontSize),
            )),
          ),
        ),
      );
    }));
  }
}
