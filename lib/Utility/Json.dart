import 'dart:convert';
import 'package:flutter/foundation.dart'; // kIsWeb
// Mobile-spezifisch
import 'dart:io' show File;
import 'package:path_provider/path_provider.dart';
// Web-spezifisch
import 'dart:html' as html;

class Json {
  late File _json; // nur für Mobile
  Map<String, dynamic> _jsonData = {};
  bool _isLoading = true;
  Map<String, dynamic> get jsonData => _jsonData;

  Future<void> _queue = Future.value();

  static final Json _instance = Json._internal();
  factory Json() => _instance;
  Json._internal();

  Future<void> initJson() async {
    _isLoading = true;
    try {
      if (kIsWeb) {
        await _initWebJson();
      } else {
        await _initMobileJson();
      }
    } catch (e) {
      print('Fehler beim InitJson: $e');
      await resetJson();
    }
    _isLoading = false;
  }

  /// Mobile: Datei laden oder erstellen
  Future<void> _initMobileJson() async {
    final directory = await getApplicationDocumentsDirectory();
    _json = File('${directory.path}/DraftlyData.json');

    if (!await _json.exists()) {
      await _json.create();
      _jsonData = _defaultTemplate();
      await writeJson();
    } else {
      await readJsonData();
    }
  }

  /// Web: LocalStorage laden oder erstellen
  Future<void> _initWebJson() async {
    try {
      final data = html.window.localStorage['DraftlyData'];
      if (data != null) {
        _jsonData = jsonDecode(data);
      } else {
        _jsonData = _defaultTemplate();
        await _writeWebJson();
      }
    } catch (e) {
      print('Fehler beim Web Init: $e');
      _jsonData = _defaultTemplate();
      await _writeWebJson();
    }
  }

  Map<String, dynamic> _defaultTemplate() {
    return {
      "Settings": {"XmlPath": ""},
      "Variables": {"Vorname": "", "Nachname": "", "Geburtstag": ""},
      "Templates": {},
      "Emails": [],
    };
  }

  /// Liest JSON-Daten
  Future<void> readJsonData() async {
    _isLoading = true;
    try {
      if (kIsWeb) {
        final data = html.window.localStorage['DraftlyData'];
        if (data != null) _jsonData = jsonDecode(data);
      } else {
        final String response = await _json.readAsString();
        _jsonData = jsonDecode(response);
      }
    } catch (e) {
      print('Fehler beim readJsonData: $e');
      await resetJson();
    } finally {
      _isLoading = false;
    }
  }

  Future<void> writeJson() async {
    if (kIsWeb) {
      await _writeWebJson();
    } else {
      _queue = _queue.then((_) async {
        await _json.writeAsString(jsonEncode(_jsonData));
      });
      await _queue;
    }
  }

  Future<void> _writeWebJson() async {
    try {
      html.window.localStorage['DraftlyData'] = jsonEncode(_jsonData);
    } catch (e) {
      print('Fehler beim Web Write: $e');
    }
  }

  Future<void> updateJson(String key, dynamic newValue) async {
    _jsonData[key] = newValue;
    await writeJson();
  }

  Future<void> updateSetting(String key, dynamic newValue) async {
    _jsonData["Settings"][key] = newValue;
    await writeJson();
  }

  Future<bool> checkJson() async {
    try {
      await readJsonData();
      return true;
    } catch (_) {
      return false;
    }
  }

  bool getIsLoading() => _isLoading;

  Future<void> resetJson() async {
    _isLoading = true;
    _queue = Future.value();
    if (kIsWeb) {
      html.window.localStorage.remove('DraftlyData');
      await _initWebJson();
    } else {
      if (await _json.exists()) await _json.delete();
      await _initMobileJson();
    }
    _isLoading = false;
  }
}