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
  Quiz? quiz;
  List<Question>? listQuestions;
  PlayPage({
    Key? key,
    this.quiz,
    this.listQuestions,
  }) : super(key: key);

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  int i = 0;
  //
  List<bool> isClick = [];
  //
  List<bool> isChoice = [];
  //
  bool onTap = false;
  //
  int timePlay = 0;
  //
  int left = 0;
  //
  int questionsLength = 0;
  //
  int right = 0;
  //
  late Question question;
  //
  @override
  void initState() {
    super.initState();

    questionsLength = widget.listQuestions!.length;
    //
    right = questionsLength;
    //
    isClick = List.generate(10, (index) => false);
    //
    isChoice = List.generate(questionsLength, (index) => false);
    Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        timePlay = timer.tick;
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    for (int i = 0; i < widget.listQuestions!.length; i++) {
      Database().deleteAnswerByQuestions(widget.listQuestions!.elementAt(i));
    }
  }

  @override
  Widget build(BuildContext context) {
    question = widget.listQuestions!.elementAt(i);
    return SafeArea(
      child: Scaffold(
          backgroundColor: kbackgroundColor,
          appBar: header(),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              //questions
              Padding(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 10, right: 20, left: 20),
                child: Text(
                  question.content,
                  style: const TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.w500),
                ),
              ),
              answer(),
              const Spacer(),
              footer(context, question)
            ],
          )),
    );
  }

  AppBar header() {
    return AppBar(
      leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          }),
      centerTitle: true,
      title: Text(widget.quiz!.name,
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: titleFontSize)),
      bottom: PreferredSize(
          preferredSize: const Size(0, 50),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: List.generate(i, (index) {
                      if (index > 5) {
                        return Container();
                      }
                      return Container(
                          height: 3,
                          width: 15,
                          margin: const EdgeInsets.all(5),
                          color: kLevelColor);
                    }),
                  ),
                ),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                      color: isChoice[i] ? Colors.orange : Colors.white,
                      shape: BoxShape.circle),
                  child: Center(
                      child: Text(
                    "${i + 1}",
                    style: TextStyle(
                      color: isChoice[i] ? Colors.white : kPrimaryColor,
                    ),
                  )),
                ),
                Expanded(
                  child: Row(
                    children:
                        List.generate(questionsLength - left - 1, (index) {
                      if (index > 5) {
                        return Container();
                      }
                      return Container(
                          height: 3,
                          width: 15,
                          margin: const EdgeInsets.all(5),
                          color: kLevelColor);
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
            // Database().updateAnswerByQuestions(question, null);
            nextQuestion(context, null);
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
                (i >= widget.listQuestions!.length - 1) ? "Finish" : "Next",
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
  void nextQuestion(BuildContext context, Answer? answer) async {
    if (i >= questionsLength - 1) {
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
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => ResultPage(
                                    listQuestions: widget.listQuestions!,
                                    quiz: widget.quiz!,
                                    timePlay: timePlay,
                                  )),
                          (route) => route.isFirst);
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
        setState(() {
          i += 1;
        });
        if (left < questionsLength) {
          ++left;
          right--;
        }
      }
    }
  }

  Widget answer() {
    return Column(
        children: List<Widget>.generate(question.answers.length, (j) {
      Answer answer = question.answers.elementAt(j);
      Answer? answerChoice = Database().loadData(question.id.toString());
      return GestureDetector(
        onTap: !onTap
            ? () {
                setState(() {
                  onTap = !onTap;
                  isChoice[i] = true;
                  isClick[j] = !isClick[j];
                });
                Future.delayed(const Duration(milliseconds: 500), () async {
                  isClick[j] = !isClick[j];
                  Database().updateAnswerByQuestions(question, answer);
                  nextQuestion(context, answer);
                  onTap = !onTap;
                });
              }
            : null,
        child: Container(
          constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width, maxHeight: 40),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                  color: answerChoice == null
                      ? isClick[j]
                          ? kPrimaryColor
                          : Colors.grey
                      : answerChoice.id == answer.id
                          ? kPrimaryColor
                          : Colors.grey),
              borderRadius: BorderRadius.circular(90)),
          child: Center(
              child: Text(
            answer.content,
            style: const TextStyle(fontSize: bodyFontSize),
          )),
        ),
      );
    }));
  }
}
