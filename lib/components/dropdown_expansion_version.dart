import 'package:flutter/material.dart';

class DropdownExpansionVersion extends StatefulWidget {
  const DropdownExpansionVersion(
      {super.key,
        required this.currentVersion,
        required this.availableVersions,
        required this.onChanged});

  final String currentVersion;
  final List<String> availableVersions;
  final void Function(String? newVersion) onChanged;

  @override
  State<DropdownExpansionVersion> createState() => _DropdownExpansionVersionState();
}

class _DropdownExpansionVersionState extends State<DropdownExpansionVersion> {
  @override
  Widget build(BuildContext context) {
    String dropdownValue = widget.availableVersions.contains(widget.currentVersion)
        ? widget.currentVersion
        : widget.availableVersions.first;
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      onChanged: (String? value) {
        setState(() {
          widget.onChanged(value);
        });
      },
      items: widget.availableVersions
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
