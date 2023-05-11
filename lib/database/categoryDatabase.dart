import 'dart:convert';

import 'package:english_quiz/model/categories.dart';
import 'package:english_quiz/model/quiz.dart';
import 'package:hive/hive.dart';

import '../services/api_services.dart';
import '../utils/constant_value.dart';

final myBox = Hive.box('myBox');

class CategoryDatabase {
  Future<void> createDefaultDB() async {
    //get category
    await ApiService().getAPI(baseURL + categoryURL, categoryURL).then((value) {
      var map = jsonDecode(value.toString());
      List l = map['categories'];
      List<Category> categoryList =
          List<Category>.from(l.map((e) => Category.fromMap(e)));
      myBox.put(categoryDB, categoryList);
    });
    //
    for (int i = 3; i < 9; i++) {
      await ApiService()
          .getAPI(baseURL + '${quizURL}$i', '${quizURL}$i')
          .then((value) {
        var map = jsonDecode(value.toString());
        List l = map['quiz'];
        List<Quiz> quizList = List<Quiz>.from(l.map((e) => Quiz.fromMap(e)));
        myBox.put('${quizDB}$i', quizList);
        // List<Quiz> categoryList = List<Quiz>.from(l.map((e) => Quiz.fromMap(e)));
        // myBox.put('quizDB', categoryList);
      });
    }
  }

  loadData(String nameDB) {
    // ApiService().getAPI(baseURL + categoryURL, categoryURL).then((value) {
    // print(myBox.get('quizDB'));
    // });
    return myBox.get(nameDB);
  }
}
