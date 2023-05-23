// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:english_quiz/database/Database.dart';
import 'package:english_quiz/model/answer.dart';
import 'package:english_quiz/model/question.dart';
import 'package:english_quiz/model/quiz.dart';
import 'package:english_quiz/services/api_services.dart';
import 'package:english_quiz/utils/color.dart';
import 'package:english_quiz/utils/constant_value.dart';
import 'package:english_quiz/utils/font.dart';
import 'package:textfield_tags/textfield_tags.dart';

// ignore: must_be_immutable
class ResultPage extends StatefulWidget {
  List<Question>? listQuestions;
  Quiz? quiz;
  int? timePlay;
  ResultPage({
    Key? key,
    this.listQuestions,
    this.quiz,
    this.timePlay,
  }) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  TextEditingController emailController = TextEditingController();
  final TextfieldTagsController _controller = TextfieldTagsController();
  String name = Database().loadData(nameDB);
  List<int> correctAnswer = [];
  List<int> wrongAnswer = [];
  int score = 0;
  String content = "";

  //format time
  String intToTime(int value) {
    int h, m, s;
    String result = "";
    h = value ~/ 3600;

    m = ((value - h * 3600)) ~/ 60;

    s = value - (h * 3600) - (m * 60);
    if (h == 0 && m != 0) {
      result = "$m minutes";
    } else if (h == 0 && m == 0) {
      result = "$s seconds";
    } else {
      result = "$h hours $m minutes $s seconds";
    }
    return result;
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.listQuestions!.length; i++) {
      Answer? answerChoice =
          Database().loadData(widget.listQuestions!.elementAt(i).id.toString());
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
    score = correctAnswer.length;
    content =
        "$name finished the test with $score/${widget.listQuestions!.length} scores in ${intToTime(widget.timePlay!)}";
    int highScore = Database().loadData('$scoreDB${widget.quiz!.id}');
    if (score > highScore) {
      Database().updateHighScore(widget.quiz!.id, score);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: kbackgroundColor,
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.of(context).pop();
                  }
                },
                icon: const Icon(Icons.home)),
            title: const Text(
              'RESULT TEST',
              style: TextStyle(color: Colors.white, fontSize: titleFontSize),
            ),
            actions: [
              //share result to email
              IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        int statusCode = 0;
                        String errorText = "";
                        return StatefulBuilder(
                          builder: (context, setS) {
                            switch (statusCode) {
                              case 200:
                                return successForm();
                            }
                            return SingleChildScrollView(
                              child: AlertDialog(
                                title: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade300))),
                                  child: Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(right: 20),
                                        child: Text(
                                          'To:',
                                          style:
                                              TextStyle(fontSize: bodyFontSize),
                                        ),
                                      ),
                                      Flexible(
                                          child: TextFieldTags(
                                        textfieldTagsController: _controller,
                                        textSeparators: const [' ', ','],
                                        letterCase: LetterCase.normal,
                                        validator: (String tag) {
                                          bool emailValid = RegExp(
                                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                              .hasMatch(tag);
                                          if (!emailValid) {
                                            setS(
                                              () {
                                                errorText = "Invalid email";
                                              },
                                            );
                                            return "Invalid email";
                                          }
                                          return null;
                                        },
                                        inputfieldBuilder: (context, tec, fn,
                                            error, onChanged, onSubmitted) {
                                          return ((context, sc, tags,
                                              onTagDelete) {
                                            return ConstrainedBox(
                                              constraints: const BoxConstraints(
                                                  minHeight: 30, maxHeight: 80),
                                              child: SingleChildScrollView(
                                                controller: sc,
                                                scrollDirection: Axis.vertical,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: tags
                                                            .map((String tag) {
                                                          return GestureDetector(
                                                            onTap: () {
                                                              onTagDelete(tag);
                                                            },
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(2),
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(2),
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .grey),
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          20.0),
                                                                ),
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Text(
                                                                    tag,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          4.0),
                                                                  const Icon(
                                                                      Icons
                                                                          .cancel,
                                                                      size:
                                                                          14.0,
                                                                      color: Colors
                                                                          .grey)
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        }).toList()),
                                                    TextField(
                                                      controller: tec,
                                                      focusNode: fn,
                                                      keyboardType:
                                                          TextInputType
                                                              .emailAddress,
                                                      decoration:
                                                          InputDecoration(
                                                        errorText: error != null
                                                            ? null
                                                            : null,
                                                        border:
                                                            const UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .transparent,
                                                              width: 1.0),
                                                        ),
                                                        enabledBorder:
                                                            const UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .transparent,
                                                              width: 1.0),
                                                        ),
                                                        errorBorder:
                                                            const UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .transparent,
                                                              width: 1.0),
                                                        ),
                                                        //  errorText: error,
                                                        focusedBorder:
                                                            const UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .transparent,
                                                              width: 1.0),
                                                        ),
                                                        hintText: "email",
                                                      ),
                                                      onChanged: onChanged,
                                                      onSubmitted: onSubmitted,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                        },
                                      ))
                                    ],
                                  ),
                                ),
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Subject:',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    Text(
                                      widget.quiz!.name,
                                      style: const TextStyle(
                                          color: Colors.black54),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(top: 15),
                                      child: Text(
                                        'Content:',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    Text(content,
                                        style: const TextStyle(
                                            color: Colors.black54)),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Text(
                                        errorText,
                                        style: const TextStyle(
                                            color: Colors.redAccent),
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        emailController.clear();
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(color: kPrimaryColor),
                                      )),
                                  ElevatedButton(
                                    onPressed: () async {
                                      // //has tag
                                      if (_controller.hasTags) {
                                        String email =
                                            _controller.getTags!.join(',');
                                        Map<String, dynamic> data = {
                                          "subject": widget.quiz!.name,
                                          "content": content,
                                          "receivers": email
                                        };
                                        showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (context) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            });
                                        int a = await ApiService().postAPI(
                                            baseURL + sendMailURL,
                                            sendMailURL,
                                            data);
                                        // ignore: use_build_context_synchronously
                                        Navigator.of(context).pop();
                                        setS(
                                          () {
                                            statusCode = a;
                                          },
                                        );
                                      } else {
                                        bool emailValid = RegExp(
                                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                            .hasMatch(_controller
                                                .textEditingController!.text);
                                        if (emailValid) {
                                          String email = _controller
                                              .textEditingController!.text
                                              .split("")
                                              .join(",");
                                          Map<String, dynamic> data = {
                                            "subject": widget.quiz!.name,
                                            "content": content,
                                            "receivers": email
                                          };
                                          showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (context) {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              });
                                          int a = await ApiService().postAPI(
                                              baseURL + sendMailURL,
                                              sendMailURL,
                                              data);
                                          // ignore: use_build_context_synchronously
                                          Navigator.of(context).pop();
                                          setS(
                                            () {
                                              statusCode = a;
                                            },
                                          );
                                        } else {
                                          setS(
                                            () {
                                              errorText = "invalid email";
                                            },
                                          );
                                        }
                                      }
                                    },
                                    child: const Text(
                                      'Send',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.share))
            ],
          ),
          body: body()),
    );
  }

  SingleChildScrollView body() {
    return SingleChildScrollView(
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
                    color: Colors.greenAccent.shade400, shape: BoxShape.circle),
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
                    color: Colors.redAccent.shade400, shape: BoxShape.circle),
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
            children:
                List<Widget>.generate(widget.listQuestions!.length, (index) {
              Question question = widget.listQuestions!.elementAt(index);
              Answer? answerChoice = Database().loadData(
                  widget.listQuestions!.elementAt(index).id.toString());
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
                    children: List.generate(question.answers.length, (index) {
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
                                        ? answerChoice.id == answer.id
                                            ? answerChoice.correct == 1
                                                ? Colors.greenAccent
                                                : Colors.redAccent
                                            : answer.correct == 1
                                                ? Colors.greenAccent
                                                : Colors.grey
                                        : answer.correct == 1
                                            ? Colors.greenAccent
                                            : Colors.grey,
                                  )),
                              child: Center(
                                child: Text(
                                  answer.content,
                                  style:
                                      const TextStyle(fontSize: bodyFontSize),
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
                                            color: answerChoice.correct == 1
                                                ? Colors.greenAccent.shade400
                                                : Colors.redAccent.shade400,
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
    );
  }

  AlertDialog successForm() {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      title: Column(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 50,
            color: Colors.greenAccent.shade400,
          ),
          Text(
            'SUCCESS!',
            style: TextStyle(fontSize: 25, color: Colors.greenAccent.shade400),
          )
        ],
      ),
      content: const Text(
        'Your result test has been sent',
        style: TextStyle(fontSize: bodyFontSize),
      ),
      actions: [
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll(Colors.greenAccent.shade400)),
            onPressed: () {
              emailController.clear();
              Navigator.of(context).pop();
            },
            child: const Text(
              "Done",
              style: TextStyle(color: Colors.white, fontSize: bodyFontSize),
            ))
      ],
    );
  }
}
