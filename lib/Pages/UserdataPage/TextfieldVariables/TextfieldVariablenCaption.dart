import 'package:flutter/material.dart';
import 'package:krankmelde_app/Utility/Caption.dart';

class TextfieldVariablenCaption extends StatelessWidget {
  const TextfieldVariablenCaption({super.key});

  @override
  Widget build(BuildContext context) {
    return Caption(
      title: "Textfeldvariablen",
      infoWidgets: [
        Text(
          "In diesem Bereich kannst du individuelle Textfelder anlegen, ihnen einen Titel zuweisen und anschließend einen Wert hinterlegen. Über die danebenliegenden Schaltflächen lässt sich der Titel eines Textfelds jederzeit bearbeiten oder das gesamte Textfeld löschen."
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'Auf der E-Mail Seite kannst du die in den Textfeldern hinterlegten Werte als Variable verwenden. Um eine Variable einzufügen, schreibe den jeweiligen Titel des Textfelds einfach in "<>". Beim Versenden der E-Mail wird diese Variable automatisch durch den zugehörigen Wert ersetzt.',
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Beispiel:",
          style: TextStyle(decoration: TextDecoration.underline, fontSize: 15),
        ),
        Text(
          "<aktuellesDatum>",
          style: TextStyle(
            color: Color.fromARGB(255, 0, 117, 130),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        )
      ],
    );
  }
}
