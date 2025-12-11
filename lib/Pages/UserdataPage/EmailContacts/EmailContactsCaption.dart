import 'package:flutter/material.dart';
import 'package:krankmelde_app/Utility/Caption.dart';

class EmailContactsCaption extends StatelessWidget {

  const EmailContactsCaption({super.key});

  @override
  Widget build(BuildContext context) {
    return Caption(
      title: "XML-Import",
      infoWidgets: [
        Text(
          "Hier kannst du eine XML-Datei importieren, um E-Mail-Kontakte automatisch hinzuzufügen. Alternativ kannst du Kontakte auch manuell über das Plus-Symbol erstlelen und hinzufügen.",
        ),
        SizedBox(height: 20),
        Text(
          "XML Beispiel:",
          style: TextStyle(decoration: TextDecoration.underline, fontSize: 20),
        ),
        SizedBox(height: 10),
        Text('''
<emailList>
    <email> kontakt1@beispiel.com </email>
    <email> kontakt2@beispiel.com </email>
    <email> kontakt3@beispiel.com </email>
<emailList>
'''),
        Text(
          'Diese Email-Adressen kannst du anschließend auf der Email-Seite bei "Empfänger" und "CC" auswählen um ihnen eine neue Nachricht zu senden.',
        ),
      ],
    );
  }
}
