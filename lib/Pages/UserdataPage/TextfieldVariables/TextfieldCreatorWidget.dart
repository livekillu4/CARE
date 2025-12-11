import 'package:flutter/material.dart';
import 'package:krankmelde_app/Utility/AlertNotification.dart';
import 'package:krankmelde_app/Pages/UserdataPage/TextfieldVariables/TextfieldGenerator.dart';
import 'package:krankmelde_app/Pages/UserdataPage/TextfieldVariables/TextfieldVariablenCaption.dart';
import 'package:krankmelde_app/main.dart';
import 'package:krankmelde_app/Pages/UserdataPage/TextfieldVariables/TextfieldVariableWidget.dart';

class TextfieldCreator {
  final GlobalKey<TextfieldCreatorState> _textfieldCreatorKey =
      GlobalKey<TextfieldCreatorState>();
  final List<TextfieldVariable> _textfieldList = [];
  late TextfieldCreatorWidget _textfieldCreatorWidget;


  TextfieldCreator() {
    _textfieldCreatorWidget = TextfieldCreatorWidget(
      key: _textfieldCreatorKey,
      list: _textfieldList,
    );
  }

  void initializeList() {
    _textfieldCreatorKey.currentState?._initializeList();
  }

  //Getter für Widget
  Widget getWidget() {
    return _textfieldCreatorWidget;
  }

  //speichert Textfield in Json
  void saveTextfields() {
    Map<String, String> dic = {};
    for (var item in _textfieldList) {
      dic[item.getTitle()] = item.getText();
    }
    MyApp.emailTemplate.updateJson("Variables", dic);
  }

  //läd Text in die Textfelder
  void loadText() {
    for (var item in _textfieldList) {
      item.loadText();
    }
  }
}

class TextfieldCreatorWidget extends StatefulWidget {
  final List<TextfieldVariable>? list;
  const TextfieldCreatorWidget({super.key, this.list});

  @override
  State<TextfieldCreatorWidget> createState() => TextfieldCreatorState();
}

class TextfieldCreatorState extends State<TextfieldCreatorWidget> {
  dynamic get list => widget.list;
  late IconButton _addButton;
  bool initialized = false;

  @override
  void initState() {
    super.initState();
    _addButton = IconButton(onPressed: _addTextfield, icon: Icon(Icons.add));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextfieldVariablenCaption(),
        Wrap(spacing: 20, runSpacing: 40, children: _getList()),
      ],
    );
  }

  //erstellt Widget Liste aus TextfeildVariable List
  List<Widget> _getList() {
    List<Widget> emptyList = [];
    list.forEach((widget) {
      emptyList.add(widget.getWidget());
    });
    emptyList.add(
      Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.onPrimary,
            width: 0.5,
          ),
          shape: BoxShape.circle,
        ),
        child: _addButton,
      ),
    );
    return emptyList;
  }

  //fügt TextfieldVariable in Liste hinzu
  void _addTextfield() async {
    String? title = await _setTitle();

    if (title != null && title.isNotEmpty && _duplicateCheck(title)) {
      setState(() {
        list.add(TextfieldVariable(title, _deleteTextfieldVariable));
      });
    }
  }

  //schaut ob ein bestimmtes Textfeld schon existiert
  bool _duplicateCheck(String title) {
    for (var textfield in list) {
      if (textfield.getTitle() == title || title == "aktuellesDatum") {
        AlertNotification.alert('"$title" existiert schon!', context);
        return false;
      }
    }
    return true;
  }

  //erstellt TextfieldVariables aus Json und fügt die zur List hinzu
  void _initializeList() {
    if(initialized) return;
    list.clear();
    Map<String, dynamic>? jsonList = MyApp.emailTemplate.jsonData["Variables"];
    if (jsonList != null && jsonList.isNotEmpty) {
      setState(() {
        for (var key in jsonList.keys) {
          final textfieldVariable = TextfieldVariable(key, _deleteTextfieldVariable);
          textfieldVariable.loadText();
          list.add(textfieldVariable);
        }
      });
    }
    initialized = true;
  }

  //entfernt TextfieldVariable
  void _deleteTextfieldVariable(TextfieldVariable item) async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => list.remove(item));
  }

  //öffnet Dialog mit Textfeld für Titel des Textfelds
  Future<String?> _setTitle() async {
    TextfieldGenerator textfield = TextfieldGenerator(
      size: 100,
      title: "Titel",
    );

    return await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Titel'),
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
                Navigator.pop(context, textfield.getController().text);
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
  }
}
