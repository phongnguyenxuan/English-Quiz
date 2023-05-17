// ignore_for_file: file_names
import 'dart:convert';

import 'package:english_quiz/model/answer.dart';
import 'package:english_quiz/model/categories.dart';
import 'package:english_quiz/model/question.dart';
import 'package:english_quiz/model/quiz.dart';
import 'package:hive/hive.dart';

import '../services/api_services.dart';
import '../utils/constant_value.dart';

final myBox = Hive.box('myBox');

class Database {
  Future<void> createDefaultDB() async {
    //get category
    await ApiService().getAPI(baseURL + categoryURL, categoryURL).then((value) {
      var map = jsonDecode(value.toString());
      List l = map['categories'];
      List<Category> categoryList =
          List<Category>.from(l.map((e) => Category.fromMap(e)));
      myBox.put(categoryDB, categoryList);
    });
    //get quiz
    for (int i = 3; i < 9; i++) {
      await ApiService()
          .getAPI('$baseURL$quizURL$i', '$quizURL$i')
          .then((value) {
        var map = jsonDecode(value.toString());
        List l = map['quiz'];
        List<Quiz> quizList = List<Quiz>.from(l.map((e) => Quiz.fromMap(e)));
        myBox.put('$quizDB$i', quizList);
      });
    }
    //insert default name
    myBox.put(nameDB, 'Anonymous');
  }

  Future<void> getQuestionsByQuizId(int id) async {
    await ApiService()
        .getAPI('$baseURL$questionsURL$id', '$questionsURL$id')
        .then((value) {
      var map = jsonDecode(value.toString());
      var count = map['count'];
      myBox.put('count$id', count);
      List l = map['questions'];
      List<Question> questionsList =
          List<Question>.from(l.map((e) => Question.fromMap(e)));
      myBox.put('$questionsDB$id', questionsList);
      //init score
      updateHighScore(id, 0);
    });
  }

  updateHighScore(int quizId, int score) {
    myBox.put('$scoreDB$quizId', score);
  }

  updateAnswerByQuestions(Question question, Answer? answer) {
    myBox.put('${question.id}', answer);
  }

  updateName(String name) {
    myBox.put(nameDB, name);
  }

  loadData(String nameDB) {
    return myBox.get(nameDB);
  }
}
