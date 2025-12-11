import 'package:flutter/material.dart';

class Caption extends StatelessWidget {
  final String title;
  final List<Widget> infoWidgets;

  const Caption({super.key, required this.title, required this.infoWidgets});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 25,
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),

        IconButton(
          icon: Icon(Icons.info_outline),
          onPressed: () => _showInfoDialog(context),
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ],
    );
  }

  // Öffnet einen AlertDialog mit den ganzen Informationen/Widgets die vorher im Konstruktor übergeben wurden
  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: infoWidgets,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
          ),
        ],
      ),
    );
  }
}
