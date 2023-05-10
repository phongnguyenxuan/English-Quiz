// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Category {
  int id;
  String name;
  String urlQuizId;

  Category({
    required this.id,
    required this.name,
    required this.urlQuizId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'url_quiz_id': urlQuizId,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as int,
      name: map['name'] as String,
      urlQuizId: map['url_quiz_id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'category(id: $id, name: $name, url_quiz_id: $urlQuizId)';
}
