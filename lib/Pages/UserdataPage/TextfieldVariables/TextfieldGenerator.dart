import 'package:flutter/material.dart';
import 'package:krankmelde_app/main.dart';

class TextfieldGenerator {
  late TextfieldGeneratorWidget _textfield;
  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<String> titleNotifier;
  final ValueNotifier<String> textNotifier = ValueNotifier("");

  TextfieldGenerator({
    required double size,
    required String title,
    double? fontSize,
  }) : titleNotifier = ValueNotifier(title) {
    _textfield = TextfieldGeneratorWidget(
      size: size,
      controller: _controller,
      fontSize: fontSize,
      titleNotifier: titleNotifier,
      textNotifier: textNotifier,
    );
  }

  //Getter für Widget
  TextfieldGeneratorWidget getWidget() {
    return _textfield;
  }

  //Getter für Controller
  TextEditingController getController() {
    return _controller;
  }

  //Speichert Textfeld in Json
  void save() {
    _textfield.save();
  }

  //Getter für Titel des Textfelds
  String getTitle() {
    return titleNotifier.value;
  }

  //Setter für Titel
  void setTitle(String title) {
    titleNotifier.value = title;
  }

  //Läd Inhalt des Textfelds aus Json
  void loadText() {
    try {
      if (MyApp.emailTemplate.jsonData.isNotEmpty) {
        textNotifier.value =
            MyApp.emailTemplate.jsonData["Variables"][titleNotifier.value] ??
            '';
      }
    } catch (error) {
      print(error);
    }
  }
}

class TextfieldGeneratorWidget extends StatefulWidget {
  final double size;
  final double? fontSize;
  final TextEditingController controller;
  final ValueNotifier<String> textNotifier;
  final ValueNotifier<String> titleNotifier;

  const TextfieldGeneratorWidget({
    super.key,
    required this.size,
    this.fontSize,
    required this.controller,
    required this.titleNotifier,
    required this.textNotifier,
  });

  @override
  State<TextfieldGeneratorWidget> createState() => TextfieldGeneratorState();

  void save() {
    MyApp.emailTemplate.updateJson(titleNotifier.value, controller.text);
  }
}

class TextfieldGeneratorState extends State<TextfieldGeneratorWidget> {
  double get _size => widget.size;
  TextEditingController get _controller => widget.controller;
  double? get fontSize => widget.fontSize;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _size,
      child: ValueListenableBuilder(
        valueListenable: widget.titleNotifier,
        builder: (context, title, child) {
          return ValueListenableBuilder(
            valueListenable: widget.textNotifier,
            builder: (context, text, child) {
              _controller.text = text;
              return TextFormField(
                controller: _controller,
                cursorColor: Theme.of(context).colorScheme.onPrimary,
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  labelText: title,
                ),
                style: TextStyle(
                  fontSize: fontSize,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
               );
            },
          );
        },
      ),
    );
  }
}
