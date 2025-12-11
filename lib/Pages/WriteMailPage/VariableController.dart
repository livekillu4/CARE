import 'package:flutter/material.dart';
import 'package:krankmelde_app/main.dart';


class VariableController extends TextEditingController {
  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    final text = this.text;

    final regexp = RegExp(r"<([^>]+)>");

    final List<InlineSpan> list = [];
    int start = 0;
    for (final match in regexp.allMatches(text)) {
      if (match.start > start) {
        list.add(TextSpan(
          text: text.substring(start, match.start),
          style: style,
        ));
      }

      final inside = match.group(1)!; 

      if (MyApp.emailTemplate.jsonData["Variables"].keys.contains(inside) || inside == "aktuellesDatum") {
        list.add(TextSpan(
          text: match.group(0),
          style: style!.copyWith(color: Color.fromARGB(255, 0, 117, 130),fontWeight: FontWeight.bold),
        ));
      } else {
        list.add(TextSpan(
          text: match.group(0),
          style: style,
        ));
      }

      start = match.end;
    }

    if (start < text.length) {
      list.add(TextSpan(
        text: text.substring(start),
        style: style,
      ));
    }


    return TextSpan(style: style, children: list);
  }
  
}