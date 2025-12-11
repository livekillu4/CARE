import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:krankmelde_app/Utility/AlertNotification.dart';
import 'package:krankmelde_app/Utility/ButtonGenerator.dart';
import 'package:krankmelde_app/Pages/PagesInterface.dart';
import 'package:krankmelde_app/Pages/UserdataPage/EmailContacts/EmailContactsWidget.dart';
import 'dart:core';
import 'package:krankmelde_app/Pages/UserdataPage/TextfieldVariables/TextfieldCreatorWidget.dart';
import 'package:krankmelde_app/main.dart';
import 'dart:convert';

class UserData implements PagesInterface {
  final TextfieldCreator _textfieldCreatorWidget = TextfieldCreator();
  late UserDataWidget _userdata;
  final EmailContacts _emailContactsWidget = EmailContacts();

  UserData() {
    _userdata = UserDataWidget(
      textfieldCreatorWidget: _textfieldCreatorWidget,
      emailContactsWidget: _emailContactsWidget,
    );
  }


  @override
  NavigationDestination getNavigationDestination() {
    return NavigationDestination(
      icon: Icon(Icons.manage_accounts),
      label: 'Persönliche Daten',
    );
  }

  @override
  Widget getButtonText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [Icon(Icons.save), Text("Speichern")],
    );
  }

  @override
  UserDataWidget getWidget() {
    _textfieldCreatorWidget.initializeList();
    return _userdata;
  }

  @override
  void getFunction(BuildContext context) {
    final oldJson = jsonDecode(jsonEncode(MyApp.emailTemplate.jsonData));
    _textfieldCreatorWidget.saveTextfields();
    _emailContactsWidget.save();
    if(jsonEncode(oldJson) != jsonEncode(MyApp.emailTemplate.jsonData)) AlertNotification.alert("Daten gespeichert!", context);
  }
}

class UserDataWidget extends StatefulWidget {
  final EmailContacts emailContactsWidget;
  final TextfieldCreator textfieldCreatorWidget;
  const UserDataWidget({
    super.key,
    required this.textfieldCreatorWidget,
    required this.emailContactsWidget,
  });

  @override
  State<UserDataWidget> createState() => UserDataState();
}

class UserDataState extends State<UserDataWidget> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.textfieldCreatorWidget.initializeList();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30, top: 5),
      child: Scrollbar(
        controller: scrollController,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(30),
          controller: scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.emailContactsWidget.getWidget(),
              widget.textfieldCreatorWidget.getWidget(),
              SizedBox(height: 20),
              Center(
                child: ButtonGenerator(
                  width: 200,
                  height: 65,
                  text: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.delete,
                        color: const Color.fromARGB(255, 170, 30, 20),
                      ),
                      Text(
                        "Alles zurücksetzen",
                        style: TextStyle(
                          color: Color.fromARGB(255, 170, 30, 20),
                        ),
                      ),
                    ],
                  ),
                  function: () => resetJson(context),
                ).getWidget(),
              ),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  //löscht und erstellt Json nach Bestätigung in AlertDialog
  void resetJson(BuildContext context)async{
    final localContext = context;
    bool? confirmReset = await showDialog<bool>(
      context: localContext,
      builder: (dialogContext) => AlertDialog(
        content: Text("Möchtest du alle gespeicherten Daten zurücksetzen?",style: TextStyle(color: Theme.of(dialogContext).colorScheme.onPrimary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext,false), child: Text("Abbrechen",style: TextStyle(color: Theme.of(dialogContext).colorScheme.onPrimary))),
          TextButton(onPressed: () => Navigator.pop(dialogContext,true), child: Text("OK",style: TextStyle(color: Theme.of(dialogContext).colorScheme.onPrimary)))
        ],
      ),
    );

    if(confirmReset == true){
      await MyApp.emailTemplate.resetJson();
      Phoenix.rebirth(localContext);
    }
  }
}