//
import 'dart:io';

const String categoryDB = 'categoryDB';
//
const String quizDB = 'quizDB';
//
const String nameDB = 'nameDB';
//
const String questionsDB = 'questionsDB';
//
const String scoreDB = 'scoreDB';
//
const String baseURL = 'https://quiz-prod.techlead.vn/services/quizservices';
//
const String categoryURL = '/api/v2/categories?categoryName=English';
//
const String quizURL = '/api/v2/quiz?categoryId=';
//
const String questionsURL = '/api/v2/questions?quizId=';
//
const String sendMailURL = '/api/v2/result';
//
const String clientId = '2069';
//
const String secret = 'eImPg8zkepjOr9KmlmLhfKKCdLIK7lOR';
//
isConnectedInternet() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    return false;
  }
}
