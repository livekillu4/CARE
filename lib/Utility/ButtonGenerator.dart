import 'package:flutter/material.dart';

class ButtonGenerator{
  late ButtonGeneratorWidget _widget;
  final VoidCallback? function;

  ButtonGenerator({required double width, required double height, required Widget text, this.function}){
    _widget = ButtonGeneratorWidget(width: width,height: height,text: text,function: function);
  }
  // Getter für das Widget
  Widget getWidget(){
    return _widget;
  }
}
class ButtonGeneratorWidget extends StatefulWidget{
  final VoidCallback? function;
  final double width;
  final double height;
  final Widget text;

  const ButtonGeneratorWidget({super.key,required this.width, required this.height, required this.text, this.function});
  
  @override
  State<ButtonGeneratorWidget> createState() => ButtonGeneratorState();
}

class ButtonGeneratorState extends State<ButtonGeneratorWidget>{
  VoidCallback? get function => widget.function;
  double get width => widget.width;
  double get height => widget.height;
  Widget get text => widget.text;

  @override 
  Widget build(BuildContext context){
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.onSecondary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
              width: 0.5,
            ),
          ),
        ),
        onPressed: function,
        child: text,
      ),
    );
  }
}