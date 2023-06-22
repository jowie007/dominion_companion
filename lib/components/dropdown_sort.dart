import 'package:flutter/material.dart';

class DropdownSort extends StatefulWidget {
  const DropdownSort(
      {super.key,
      required this.sortAsc,
      required this.sortKey,
      required this.onChanged});

  final bool sortAsc;
  final String sortKey;
  final void Function(bool asc, String key) onChanged;

  @override
  State<DropdownSort> createState() => _DropdownSortState();
}

const Map<String, String> itemMap = {
  "creationDate": "Erstelldatum",
  "editDate": "Bearbeitungsdatum",
  "rating": "Bewertung",
  "name": "Name"
};

class _DropdownSortState extends State<DropdownSort> {
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
