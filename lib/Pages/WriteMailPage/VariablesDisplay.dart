import 'package:flutter/material.dart';
import 'package:krankmelde_app/main.dart';

class VariablesDisplay extends StatelessWidget {
  final ScrollController controller;
  const VariablesDisplay({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    final List<InlineSpan> list = [TextSpan(text: "<aktuellesDatum>", style: TextStyle(color: Color.fromARGB(255, 0, 117, 130), fontWeight: FontWeight.bold))];
    for (var variable in MyApp.emailTemplate.jsonData["Variables"].keys) {
      list.add(TextSpan(text: ", ", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)));
      list.add(TextSpan(text: "<$variable>", style: TextStyle(color: Color.fromARGB(255, 0, 117, 130), fontWeight: FontWeight.bold)));
    }

    return Container(
      decoration: BoxDecoration(border: Border.all(color: Theme.of(context).colorScheme.onPrimary, width: 1), borderRadius: BorderRadius.circular(8)),
      child: SizedBox(
        height: 50,
        child: Scrollbar(
          controller: controller,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
            controller: controller,
            child: RichText(text: TextSpan(children: list), maxLines: 1),
          ),
        ),
      ),
    );
  }
}