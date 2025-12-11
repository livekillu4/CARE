import 'package:flutter/material.dart';
import 'package:krankmelde_app/main.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class RecipientsSelector extends StatelessWidget {
  final String title;
  final List<String> initialValue;
  final Function(List<String>) onChanged;

  const RecipientsSelector({
    required this.title,
    required this.initialValue,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
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
      child: MultiSelectDialogField<String>(
        items: List<String>.from(
          MyApp.emailTemplate.jsonData['Emails'],
        ).map((e) => MultiSelectItem<String>(e, e)).toList(),
        title: Text(title),
        selectedColor: Theme.of(context).colorScheme.primary,
        selectedItemsTextStyle: TextStyle(color: Colors.white),
        buttonText: Text("$title auswählen"),
        buttonIcon: const Icon(Icons.people),
        listType: MultiSelectListType.CHIP,
        initialValue: initialValue,
        searchable: true,
        onConfirm: onChanged,
        chipDisplay: MultiSelectChipDisplay(
          chipColor: Theme.of(context).colorScheme.primary,
          textStyle: TextStyle(color: Colors.white),
          onTap: (value) => initialValue.remove(value),
        ),
        cancelText: Text(
          "Abbrechen",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        confirmText: Text(
          "Speichern",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

