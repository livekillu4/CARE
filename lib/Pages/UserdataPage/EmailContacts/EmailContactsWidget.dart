import 'package:flutter/material.dart';
import 'package:krankmelde_app/Pages/UserdataPage/EmailContacts/EmailContactsCaption.dart';
import 'package:krankmelde_app/Pages/UserdataPage/EmailContacts/ImportFileButton.dart';
import 'dart:core';
import 'package:krankmelde_app/main.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:krankmelde_app/Pages/UserdataPage/TextfieldVariables/TextfieldGenerator.dart';

class EmailContacts {
  final List<String> _savedEmails = [];
  late EmailContactsWidget _widget;

  static final EmailContacts _instance = EmailContacts._();

  EmailContacts._() {
    _widget = EmailContactsWidget(savedEmails: _savedEmails);
  }

  factory EmailContacts() => _instance;

  //Getter für das Widget
  Widget getWidget() {
    return _widget;
  }

  //speichert die Emails in der Json
  void save() {
    MyApp.emailTemplate.updateJson("Emails", _savedEmails);
  }
}

class EmailContactsWidget extends StatefulWidget {
  final List<String> savedEmails;
  const EmailContactsWidget({super.key, required this.savedEmails});

  @override
  State<EmailContactsWidget> createState() => _EmailContactsState();
}

class _EmailContactsState extends State<EmailContactsWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.savedEmails.isEmpty) {
        widget.savedEmails.addAll(
          List<String>.from(MyApp.emailTemplate.jsonData['Emails']),
        );
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EmailContactsCaption(),
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: selectEmails,
                style: TextButton.styleFrom(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.onPrimary,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Emails auswählen",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    Icon(
                      Icons.people_outline,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 12),
            Importfilebutton().getWidget(context),
            SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.onPrimary,
                  width: 0.5,
                ),
                shape: BoxShape.circle,
              ),
              child: IconButton(icon: Icon(Icons.add), onPressed: addEmail),
            ),
          ],
        ),
        SizedBox(
          height: 100,
          child: widget.savedEmails.isEmpty
              ? Center(child: Text("keine Emails gespeichert"))
              : ListView.builder(
                  itemCount: widget.savedEmails.length,
                  itemBuilder: (context, index) {
                    final email = widget.savedEmails[index];
                    return ListTile(
                      title: Text(email, maxLines: 1),
                      trailing: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            widget.savedEmails.removeAt(index);
                            MyApp.emailTemplate.updateJson(
                              "Emails",
                              widget.savedEmails,
                            );
                          });
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  //Loadingscreen während XML lädt => gespeicherten Mails werden hinzugefügt => MultiSelectDialog in der Emails ausgewählt werden die gespeichert werden sollen
  void selectEmails() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(child: CircularProgressIndicator()),
    );
    List<String> emails = await Importfilebutton.loadXML();

    if (!mounted) return;

    for (var email in widget.savedEmails) {
      if (!emails.contains(email)) emails.add(email);
    }

    Navigator.of(context).pop();

    await showDialog<List<String>>(
      context: context,
      builder: (_) => Theme(
        data: Theme.of(context).copyWith(
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Theme.of(context).colorScheme.onPrimary,
          ),
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ),
        child: MultiSelectDialog(
          initialValue: widget.savedEmails,
          items: emails.map((e) => MultiSelectItem<String>(e, e)).toList(),
          title: const Text("Emails auswählen"),
          selectedColor: Theme.of(context).colorScheme.onPrimary,

          selectedItemsTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          listType: MultiSelectListType.LIST,
          searchable: true,
          onConfirm: (values) {
            setState(() {
              widget.savedEmails.clear();
              widget.savedEmails.addAll(values);
              MyApp.emailTemplate.updateJson("Emails", widget.savedEmails);
            });
          },
          itemsTextStyle: TextStyle(
            overflow: TextOverflow.ellipsis,
            fontSize: 16,
            color: Theme.of(context).colorScheme.onPrimary,
          ),

          checkColor: Theme.of(context).colorScheme.onSecondary,
          cancelText: Text(
            "Abbrechen",
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
          confirmText: Text(
            "Speichern",
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
      ),
    );
  }

  //öffnet AlertDialog in dem eine Email manuell hinzugefügt werden kann und diese wird geprüft nach Format und Inhalt + Speicherung in Json am Ende
  Future<void> addEmail() async {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    TextfieldGenerator textfield = TextfieldGenerator(
      size: 100,
      title: "Email",
    );

    String? email = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Email'),
          content: textfield.getWidget(),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, null);
              },
              child: Text(
                'Abbrechen',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                if (!widget.savedEmails.contains(
                      textfield.getController().text,
                    ) &&
                    textfield.getController().text.isNotEmpty &&
                    regex.hasMatch(textfield.getController().text.trim())) {
                  Navigator.pop(context, textfield.getController().text);
                }
              },
              child: Text(
                'Speichern',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (email != null) {
      widget.savedEmails.add(email);
      MyApp.emailTemplate.updateJson("Emails", widget.savedEmails);
      setState(() {});
    }
  }
}
