// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:english_quiz/utils/font.dart';
import 'package:flutter/material.dart';

import 'package:english_quiz/utils/color.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kbackgroundColor,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'About Us',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        body: Column(
          children: [
            //logo
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: SizedBox(
                    width: 150,
                    height: 150,
                    child: Image.asset('assets/images/logo.png')),
              ),
            ),
            //body
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: BodyItem(
                      title: 'Version',
                      bodyText: 'English quiz 1.3',
                      bodyStyle: const TextStyle(
                          fontSize: bodyFontSize, color: Colors.grey),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: BodyItem(
                      title: 'Website',
                      bodyText:
                          'https://www.facebook.com/English-Quiz-101331054853888',
                      bodyStyle: const TextStyle(
                          fontSize: bodyFontSize,
                          color: kPrimaryColor,
                          decoration: TextDecoration.underline),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: BodyItem(
                      title: 'Rate US',
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: BodyItem(
                      title: 'Remove Ads',
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: BodyItem(
                      title: 'Terms of Use',
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: BodyItem(
                      title: 'Privacy Policy',
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class BodyItem extends StatelessWidget {
  String title;
  String? bodyText;
  IconData? action;
  TextStyle? bodyStyle;
  BodyItem(
      {Key? key,
      required this.title,
      this.bodyText,
      this.action,
      this.bodyStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            title,
            style: const TextStyle(fontSize: bodyFontSize),
          ),
        ),
        bodyText != null
            ? Expanded(
                child: Text(
                  bodyText!,
                  style: bodyStyle,
                ),
              )
            : Container(),
      ],
    );
  }
}
