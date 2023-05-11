// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:hive/hive.dart';
part 'quiz.g.dart';

@HiveType(typeId: 2)
class Quiz {
  @HiveField(0)
  int id;
  @HiveField(1)
  int categoryId;
  @HiveField(2)
  String name;

  Quiz({
    required this.id,
    required this.categoryId,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'category_id': categoryId,
      'name': name,
    };
  }

  factory Quiz.fromMap(Map<String, dynamic> map) {
    return Quiz(
      id: map['id'] as int,
      categoryId: map['category_id'] as int,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Quiz.fromJson(String source) =>
      Quiz.fromMap(json.decode(source) as Map<String, dynamic>);
}
