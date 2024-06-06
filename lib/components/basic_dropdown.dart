import 'package:flutter/material.dart';

class BasicDropdown extends StatefulWidget {
  const BasicDropdown(
      {super.key,
      required this.selected,
      required this.available,
      required this.onChanged});

  final String selected;
  final Map<String, String> available;
  final void Function(String? newVersion) onChanged;

  @override
  State<BasicDropdown> createState() => _BasicDropdownState();
}

class _BasicDropdownState extends State<BasicDropdown> {
  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 200),
      // Set your desired max width here
      child: DropdownButton<String>(
        isExpanded: true,
        value: dropdownValue,
        icon: const Icon(Icons.arrow_drop_down),
        elevation: 16,
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue!;
            widget.onChanged(newValue);
          });
        },
        items: widget.available.entries
            .map<DropdownMenuItem<String>>((MapEntry<String, String> entry) {
          return DropdownMenuItem<String>(
            value: entry.key,
            child: Text(
              entry.value,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
      ),
    );
  }
}
