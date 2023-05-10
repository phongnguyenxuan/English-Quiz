import 'dart:convert';

import 'package:english_quiz/model/categories.dart' as category;
import 'package:english_quiz/model/quiz.dart';
import 'package:english_quiz/utils/constant_value.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<List<category.Category>> getCategories() async {
    try {
      var url = Uri.parse(
          'https://quiz-prod.techlead.vn/services/quizservices/api/v1/categories?categoryName=English');
      var response = await http.get(url, headers: header);
      int status = response.statusCode;
      if (status == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        List l = data["categories"];
        List<category.Category> listCate = List<category.Category>.from(
            l.map((e) => category.Category.fromMap(e)));
        return listCate;
      } else {
        throw Exception("fail");
      }
    } catch (_) {
      return [];
    }
  }

  //get quiz data
  Future<List<Quiz>> getQuiz(int categoryId) async {
    try {
      var url =
          Uri.parse('https://quiz.techlead.vn/quiz?categoryId=$categoryId');
      var response = await http.get(url, headers: header);
      int status = response.statusCode;
      if (status == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        List l = data["quiz"];
        List<Quiz> listQuiz = List<Quiz>.from(l.map((e) => Quiz.fromMap(e)));
        return listQuiz;
      } else {
        throw Exception("fail");
      }
    } catch (_) {
      return [];
    }
  }
}
