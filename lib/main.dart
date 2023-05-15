import 'package:english_quiz/model/answer.dart';
import 'package:english_quiz/model/categories.dart';
import 'package:english_quiz/model/question.dart';
import 'package:english_quiz/model/quiz.dart';
import 'package:english_quiz/pages/splash.dart';
import 'package:english_quiz/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(QuizAdapter());
  Hive.registerAdapter(QuestionAdapter());
  Hive.registerAdapter(AnswerAdapter());
  await Hive.openBox('myBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Theme.of(context).copyWith(
          colorScheme:
              Theme.of(context).colorScheme.copyWith(primary: kPrimaryColor)),
      home: const Splash(),
    );
  }
}
