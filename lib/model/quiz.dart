// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Quiz {
  int id;
  int categoryId;
  String name;
  String questionsURL;

  Quiz({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.questionsURL,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'category_id': categoryId,
      'name': name,
      'questionsURL': questionsURL,
    };
  }

  factory Quiz.fromMap(Map<String, dynamic> map) {
    return Quiz(
      id: map['id'] as int,
      categoryId: map['category_id'] as int,
      name: map['name'] as String,
      questionsURL: map['questionsURL'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Quiz.fromJson(String source) =>
      Quiz.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Quiz(id: $id, category_id: $categoryId, name: $name, questionsURL: $questionsURL)';
  }
}
