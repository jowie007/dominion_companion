import 'package:flutter/material.dart';

class DropdownExpansionVersion extends StatefulWidget {
  const DropdownExpansionVersion(
      {super.key,
      required this.currentVersion,
      required this.availableVersions,
      required this.onChanged});

  final String currentVersion;
  final Map<String, String> availableVersions;
  final void Function(String? newVersion) onChanged;

  @override
  State<DropdownExpansionVersion> createState() =>
      _DropdownExpansionVersionState();
}

class _DropdownExpansionVersionState extends State<DropdownExpansionVersion> {
  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.currentVersion;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
          widget.onChanged(newValue);
        });
      },
      items: widget.availableVersions.entries
          .map<DropdownMenuItem<String>>((MapEntry<String, String> entry) {
        return DropdownMenuItem<String>(
          value: entry.key,
          child: Text(entry.value),
        );
      }).toList(),
    );
  }
}
