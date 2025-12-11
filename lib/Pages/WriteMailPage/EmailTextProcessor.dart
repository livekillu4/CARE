import 'package:krankmelde_app/main.dart';
import 'package:intl/intl.dart';

class EmailTextProcessor {
  static String replaceWithVariables(String text) {
    final regexp = RegExp(r"<([^>]+)>");
    String returnText = "";
    int start = 0;

    for (final match in regexp.allMatches(text)) {
      if (match.start > start) {
        returnText += text.substring(start, match.start);
      }

      final inside = match.group(1);

      if (MyApp.emailTemplate.jsonData["Variables"].keys.contains(inside)) {
        returnText += MyApp.emailTemplate.jsonData["Variables"][inside];
      } else if (inside == "aktuellesDatum") {
        returnText += DateFormat('dd.MM.yyyy').format(DateTime.now());
      } else {
        returnText += match.group(0)!;
      }
      start = match.end;
    }

    if (start < text.length) {
      returnText += text.substring(start);
    }
    return returnText;
  }
}