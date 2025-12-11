
import 'package:flutter/material.dart';
import 'package:krankmelde_app/Pages/UserdataPage/TextfieldVariables/TextfieldGenerator.dart';

class TextfieldVariable{
  late TextfieldVariableWidget _widget;
  late TextfieldGenerator _textfield;

  TextfieldVariable(String placeholder, Function deleteFunction){
    _textfield = TextfieldGenerator(size: 200, title: placeholder);
    _widget = TextfieldVariableWidget(deleteFunction: deleteFunction, textfield: _textfield, textfieldVariable: this);
  }

  //Getter für Widget
  Widget getWidget(){
    return _widget;
  }

  //Läd Text von Textfeldern aus Json
  void loadText(){
    _textfield.loadText();
  }

  //Speichert Textfeld in Json
  void save(){
    _textfield.save();
  }

  //Getter für Title
  String getTitle(){
    return _textfield.getTitle();
  }

  //Getter für Text aus Textfeld
  String getText(){
    return _textfield.getController().text;
  }
}

class TextfieldVariableWidget extends StatefulWidget{
  final Function deleteFunction;
  final TextfieldGenerator textfield;
  final TextfieldVariable textfieldVariable;

  const TextfieldVariableWidget({super.key, required this.deleteFunction, required this.textfield, required this.textfieldVariable});
  
  @override
  State<TextfieldVariableWidget> createState() => TextfieldVariableState();
}

class TextfieldVariableState extends State<TextfieldVariableWidget>{
  
  @override
  Widget build(BuildContext buildContext){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        widget.textfield.getWidget(),
        IconButton(onPressed: () {widget.deleteFunction(widget.textfieldVariable);}, icon: Icon(Icons.delete)),
        IconButton(onPressed: editTextfieldTitle, icon: Icon(Icons.edit))
      ],
    );
  }

  //öffnet Dialog zum ändern oder erstellen eines Textfelds
  Future<String?> openDialog() async {
    TextfieldGenerator textfield = TextfieldGenerator(
      size: 100,
      title: "Titel",
    );
    textfield.getController().text = widget.textfield.getTitle();

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
              child: Text('Abbrechen', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, textfield.getController().text);
              },
              child: Text('Speichern', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
            ),
          ],
        );
      },
    );
  }

  void editTextfieldTitle() async{
    String? title = await openDialog();

    if (title != null && title.isNotEmpty) {
      setState(() {
        widget.textfield.setTitle(title);
      });
    }
  }
}

