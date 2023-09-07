import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';


class TranslatorService{
  static final GoogleTranslator translator = GoogleTranslator();


  static dynamic translateText(String text,BuildContext context) async {
    Translation translatedText = await translator.translate("originalText", to: context.locale.languageCode);
    return translatedText.text;
  }
}