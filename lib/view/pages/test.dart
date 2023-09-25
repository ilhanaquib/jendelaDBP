import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:learning_language/learning_language.dart';

class Language extends StatefulWidget {
  const Language({super.key});

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  String text =
      'Buku negara kita mempunyai empat bahagian yang dibahagikan kepada empat belas bab';
  LanguageIdentifier identifier = LanguageIdentifier();
  String language = '';

  void checkLanguage() async {
    language = await identifier.identify(text);
  }

  @override
  void initState() {
    super.initState();
    checkLanguage();
    print(language);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [Text(language)],
    ));
  }
}
