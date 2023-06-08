import 'dart:developer';

import 'package:flutter/material.dart';

class DropdownMenu extends StatefulWidget {
  const DropdownMenu(
      {super.key,
      required this.sortAsc,
      required this.sortKey,
      required this.onChanged});

  final bool sortAsc;
  final String sortKey;
  final void Function(bool asc, String key) onChanged;

  @override
  State<DropdownMenu> createState() => _DropdownMenuState();
}

const Map<String, String> itemMap = {
  "creationDate": "Erstelldatum",
  "editDate": "Bearbeitungsdatum",
  "rating": "Bewertung",
};

// TODO Datenbank für Settings erstellen
class _DropdownMenuState extends State<DropdownMenu> {
  @override
  Widget build(BuildContext context) {
    String dropdownValue = itemMap[widget.sortKey]!;
    bool asc = widget.sortAsc;
    return DropdownButton<String>(
      value: dropdownValue,
      icon: asc == false
          ? const Icon(Icons.arrow_downward)
          : const Icon(Icons.arrow_upward),
      elevation: 16,
      onChanged: (String? value) {
        setState(() {
          widget.onChanged(dropdownValue == value ? !asc : true,
              itemMap.keys.firstWhere((key) => itemMap[key] == value));
        });
      },
      items: itemMap.entries
          .map((e) => e.value)
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
