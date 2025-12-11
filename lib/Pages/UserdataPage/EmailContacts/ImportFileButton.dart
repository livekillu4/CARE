
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:krankmelde_app/main.dart';
import 'package:xml/xml.dart';
import 'dart:async';
import 'dart:io';

class Importfilebutton {
  late IconButton _button;

  static final Importfilebutton _instance = Importfilebutton._();

  Importfilebutton._(){
    _button = IconButton(onPressed: _selectFile, icon: Icon(Icons.file_open_outlined));
  }

  factory Importfilebutton() => _instance;

  //Gibt das Widget zurück
  Widget getWidget(BuildContext context){
    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.onPrimary, width: 0.5),
          shape: BoxShape.circle,
        ),
        child: _button,
      );
  }

  //Öffnet Filepicker um eine XML auszuwählen => Speicherung von Pfad in Json 
  Future<void> _selectFile() async{
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['xml']);
    if(result != null){
      MyApp.emailTemplate.updateSetting("xmlPath",result.files.single.path.toString());
      // await checkXML();
    }
  }


  //läd den Gespeicherten Pfad
  static Future<List<String>> loadXML() async {
    final path = MyApp.emailTemplate.jsonData["Settings"]["xmlPath"] ?? "";
    final result = await compute<String, List<String>>(
      checkXML,
      path
    );
    if(result.isEmpty) MyApp.emailTemplate.updateSetting("xmlPath", "");

    return result;
  }
  
  //gibt Liste zurück mit allen Emails aus der XML, wenn XML valide
  static Future<List<String>> checkXML(String path) async{
    List<String> emailList = [];
    
    XmlDocument document; 
    if(await File(path).exists()){
      final xml = File(path);
      final content = xml.readAsStringSync();
      document = XmlDocument.parse(content);
    }else{
      return emailList;
    }


    if(checkListXML(document)){
      emailList.clear();
      for(XmlElement email in document.findAllElements("email")){
        emailList.add(email.innerText);
      }
    }

    return emailList;
  }

  //überprüft Schema deer XML
  static bool checkListXML(XmlDocument xml){
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if(xml.findAllElements('emailList').toList().length > 1) return false;
    if(xml.rootElement.name.local != 'emailList') return false;
    for(final child in xml.rootElement.children.whereType<XmlElement>()){
      if(child.name.local != 'email' || child.innerText.trim().isEmpty) return false;
      if(child.children.whereType<XmlElement>().isNotEmpty) return false;
      if(!regex.hasMatch(child.innerText.trim())) return false;
    }
    return true;
  }
}
