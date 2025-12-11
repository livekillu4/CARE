import 'package:flutter/material.dart';
import 'package:krankmelde_app/main.dart';
import 'package:krankmelde_app/Pages/WriteMailPage/EmailTemplate.dart';

class EmailTemplateManager {
  Future<List<EmailTemplate>> loadTemplates() async {
    final List<EmailTemplate> templates = [];
    for (var template in MyApp.emailTemplate.jsonData["Templates"].values) {
      templates.add(EmailTemplate.fromJson(template));
    }
    templates.insert(
      0,
      EmailTemplate(
        name: "Leere Vorlage",
        betreff: "",
        text: "",
        empfaenger: [],
        cc: [],
      ),
    );
    return templates;
  }

  Future<void> saveTemplate(String name, String betreff, String text,
      List<String> empfaenger, List<String> cc, BuildContext context) async {
    if (name == "Leere Vorlage") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Die 'Leere Vorlage' kann nicht überschrieben werden!"),
        ),
      );  
      return;
    }

    MyApp.emailTemplate.jsonData["Templates"][name] = {
      "name": name,
      "betreff": betreff,
      "text": text,
      "empfaenger": empfaenger,
      "cc": cc,
    };
    MyApp.emailTemplate.updateJson("Templates", MyApp.emailTemplate.jsonData["Templates"]);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Vorlage "$name" gespeichert!')),
    );
  }

  Future<void> deleteTemplate(String name, BuildContext context) async {
    if (name == "Leere Vorlage") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Leere Vorlage kann nicht gelöscht werden!")),
      );
      return;
    }

    MyApp.emailTemplate.jsonData["Templates"].remove(name);
    MyApp.emailTemplate.updateJson("Templates", MyApp.emailTemplate.jsonData["Templates"]);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Vorlage "$name" gelöscht!')),
    );
  }
}