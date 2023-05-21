// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:english_quiz/model/answer.dart';
import 'package:hive/hive.dart';
part 'question.g.dart';

@HiveType(typeId: 3)
class Question {
  @HiveField(0)
  int id;
  @HiveField(1)
  String content;
  @HiveField(2)
  List<Answer> answers;
  Question({
    required this.id,
    required this.content,
    required this.answers,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'content': content,
      'answers': answers.map((x) => x.toMap()).toList(),
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'] as int,
      content: map['content'] as String,
      answers: List<Answer>.from(
        map['answers'].map(
          (e) => Answer.fromMap(e as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Question.fromJson(String source) =>
      Question.fromMap(json.decode(source) as Map<String, dynamic>);
}
