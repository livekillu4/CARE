import 'package:flutter/material.dart';
import 'package:krankmelde_app/Utility/ButtonGenerator.dart';
import 'package:krankmelde_app/Pages/WriteMailPage/EmailTemplate.dart';
import 'package:krankmelde_app/Utility/Caption.dart';
import 'package:krankmelde_app/Pages/WriteMailPage/EmailTemplateManager.dart';
import 'package:krankmelde_app/Pages/WriteMailPage/RecipientsSelector.dart';
import 'package:krankmelde_app/Pages/WriteMailPage/VariablesDisplay.dart';

class WriteMailPageWidget extends StatefulWidget {
  final TextEditingController emailTextController;
  final TextEditingController betreffTextController;
  final List<String> selectedEmpfaenger;
  final List<String> selectedCCs;

  const WriteMailPageWidget({
    super.key,
    required this.emailTextController,
    required this.betreffTextController,
    required this.selectedCCs,
    required this.selectedEmpfaenger,
  });

  @override
  State<WriteMailPageWidget> createState() => _WriteMailPageWidgetState();
}

class _WriteMailPageWidgetState extends State<WriteMailPageWidget> {
  late TextEditingController _emailTextController;
  late TextEditingController _betreffTextController;
  final ScrollController scrollController = ScrollController();
  final ScrollController variablesTextboxController = ScrollController();

  String? _selectedVorlage;
  late List<String> _selectedEmpfaenger;
  late List<String> _selectedCCs;
  List<EmailTemplate> _vorlagen = [];
  final EmailTemplateManager _templateManager = EmailTemplateManager();

  @override
  void initState() {
    super.initState();
    _emailTextController = widget.emailTextController;
    _betreffTextController = widget.betreffTextController;
    _selectedEmpfaenger = widget.selectedEmpfaenger;
    _selectedCCs = widget.selectedCCs;
    _loadTemplates();
  }

  Future<void> _loadTemplates() async {
    final templates = await _templateManager.loadTemplates();
    setState(() {
      _vorlagen = templates;
      if (_selectedVorlage != null &&
          !_vorlagen.any((v) => v.name == _selectedVorlage)) {
        _selectedVorlage = null;
      }
    });
  }

  Future<void> _saveTemplateAndReload(String name) async {
    await _templateManager.saveTemplate(
      name,
      _betreffTextController.text,
      _emailTextController.text,
      _selectedEmpfaenger,
      _selectedCCs,
      context,
    );
    await _loadTemplates();
    setState(() {
      _selectedVorlage = name;
    });
  }

  Future<void> _deleteTemplateAndReload(String name) async {
    await _templateManager.deleteTemplate(name, context);
    await _loadTemplates();
    setState(() {
      _selectedVorlage = null;
      _betreffTextController.clear();
      _emailTextController.clear();
      _selectedEmpfaenger.clear();
      _selectedCCs.clear();
    });
  }

  void _showSaveDialog() async {
    final TextEditingController nameController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Vorlage speichern",style: TextStyle(color: Theme.of(context).colorScheme.onPrimary), ),
        content: TextField(
          cursorColor: Theme.of(context).colorScheme.onPrimary,
          controller: nameController,
          decoration: InputDecoration(
            labelText: "Name der Vorlage",
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
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Abbrechen",
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                _saveTemplateAndReload(name);
                Navigator.pop(context);
              }
            },
            child: Text(
              "Speichern",
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog() async {
    if (_selectedVorlage == null || _selectedVorlage!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Keine Vorlage ausgewählt!")),
      );
      return;
    }

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Vorlage "${_selectedVorlage!}" wirklich löschen?', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:  Text("Abbrechen", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
          ),
          ElevatedButton(
            onPressed: () async {
              await _deleteTemplateAndReload(_selectedVorlage!);
              Navigator.pop(context);
            },
            child:  Text("Löschen", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: scrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Caption(
              title: "Email",
              infoWidgets: [
                Text(
                  "E-Mail Vorlagen",
                  style: TextStyle(
                    fontSize: 20,
                    decoration: TextDecoration.underline,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Auf dieser Seite kannst du komplette E-Mails erstellen, inklusive Empfänger, CC, Betreff "
                  "und Nachrichtentext. Jede E-Mail kann als Vorlage gespeichert werden, um sie später schnell "
                  "wiederzuverwenden. Alle gespeicherten Vorlagen werden in einem Dropdown-Menü angezeigt und "
                  "können von dort jederzeit ausgewählt oder gelöscht werden.\n\n"
                  "Zusätzlich lassen sich Empfänger- und CC-Adressen auswählen, die du auf der vorherigen Seite "
                  "hinterlegt hast. Diese werden ebenfalls in der Vorlage gespeichert.\n\n",
                ),

                Text(
                  "Variablen verwenden",
                  style: TextStyle(
                    fontSize: 20,
                    decoration: TextDecoration.underline,
                  ),
                ),

                SizedBox(height: 10),

                Text(
                  "Im Nachrichtentext kannst du die zuvor angelegten Textfelder als Variablen nutzen. Um eine "
                  "Variable einzufügen, schreibe einfach den Titel des Textfelds in spitze Klammern, zum "
                  "Beispiel: <Name> oder <Kundennummer>. Beim Versenden der E-Mail werden diese Variablen "
                  "automatisch durch die hinterlegten Werte ersetzt.\n\n",
                ),

                Text(
                  "Email versenden",
                  style: TextStyle(
                    fontSize: 20,
                    decoration: TextDecoration.underline,
                  ),
                ),

                SizedBox(height: 10),

                Text(
                  "Wenn du auf „E-Mail senden“ klickst, öffnet sich dein standardmäßiges E-Mail-Programm. "
                  "Dort wird die vollständig vorbereitete E-Mail angezeigt: inklusive aller Empfänger, CC-Adressen, "
                  "des Betreffs und der ersetzten Variablen. Du kannst den Inhalt noch einmal überprüfen und "
                  "anschließend endgültig abschicken.",
                ),
              ],
            ),
            DropdownButtonFormField<String>(
              value: _selectedVorlage,
              decoration: InputDecoration(
                labelText: "Vorlagen",
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
              ),
              items: _vorlagen
                  .map(
                    (e) => DropdownMenuItem(value: e.name, child: Text(e.name)),
                  )
                  .toList(),
              onChanged: (value) {
                final selected = _vorlagen.firstWhere((v) => v.name == value);
                setState(() {
                  _selectedVorlage = selected.name;
                  if (selected.name == "Leere Vorlage") {
                    _betreffTextController.clear();
                    _emailTextController.clear();
                    _selectedEmpfaenger.clear();
                    _selectedCCs.clear();
                    return;
                  }
                  _betreffTextController.text = selected.betreff;
                  _emailTextController.text = selected.text;
                  _selectedEmpfaenger
                    ..clear()
                    ..addAll(selected.empfaenger);
                  _selectedCCs
                    ..clear()
                    ..addAll(selected.cc);
                });
              },
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ButtonGenerator(
                  width: 150,
                  height: 45,
                  text: Row(
                    children: [
                      Icon(Icons.save),
                      SizedBox(width: 20),
                      Text("Speichern"),
                    ],
                  ),
                  function: _showSaveDialog,
                ).getWidget(),
                ButtonGenerator(
                  width: 150,
                  height: 45,
                  text: Row(
                    children: [
                      Icon(Icons.delete),
                      SizedBox(width: 20),
                      Text("Löschen"),
                    ],
                  ),
                  function: _showDeleteDialog,
                ).getWidget(),
              ],
            ),
            const SizedBox(height: 20),
            RecipientsSelector(
              title: "Empfänger",
              initialValue: _selectedEmpfaenger,
              onChanged: (values) {
                setState(() {
                  _selectedEmpfaenger.clear();
                  _selectedEmpfaenger.addAll(values);
                });
              },
            ),
            const SizedBox(height: 20),
            RecipientsSelector(
              title: "CCs",
              initialValue: _selectedCCs,
              onChanged: (values) {
                setState(() {
                  _selectedCCs.clear();
                  _selectedCCs.addAll(values);
                });
              },
            ),
            const SizedBox(height: 20),
            VariablesDisplay(controller: variablesTextboxController),
            const SizedBox(height: 20),
            SizedBox(
              height: 50,
              child: TextField(
                controller: _betreffTextController,
                cursorColor: Theme.of(context).colorScheme.onPrimary,
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
                textAlignVertical: TextAlignVertical.top,
                decoration: textfieldDecoration("Betreff", true),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 400,
              child: TextField(
                controller: _emailTextController,
                cursorColor: Theme.of(context).colorScheme.onPrimary,
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
                textAlignVertical: TextAlignVertical.top,
                decoration: textfieldDecoration("E-Mail Text", true),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  InputDecoration textfieldDecoration(String title, bool alignLabelWithHint) {
    return InputDecoration(
      labelStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).colorScheme.onPrimary),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).colorScheme.onPrimary),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).colorScheme.onPrimary),
      ),
      labelText: title,
      alignLabelWithHint: alignLabelWithHint,
    );
  }
}
