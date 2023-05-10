// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:english_quiz/utils/font.dart';
import 'package:flutter/material.dart';

class SideItem extends StatelessWidget {
  String title;

  SideItem({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          const Icon(
            Icons.library_books_rounded,
            color: Colors.white,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style:
                  const TextStyle(color: Colors.white, fontSize: bodyFontSize),
            ),
          ),
          const Spacer(),
          const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
