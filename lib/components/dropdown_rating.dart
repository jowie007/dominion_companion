import 'package:flutter/material.dart';

class DropdownSort extends StatefulWidget {
  const DropdownSort(
      {super.key, required this.rating, required this.onChanged});

  final int? rating;
  final void Function(String? value) onChanged;

  @override
  State<DropdownSort> createState() => _DropdownSortState();
}

const Map<String, String> itemMap = {
  "-": "-",
  "1": "1",
  "2": "2",
  "3": "3",
  "4": "4",
  "5": "5",
  "6": "6",
  "7": "7",
  "8": "8",
  "9": "9",
  "10": "10",
};

class _DropdownSortState extends State<DropdownSort> {
  @override
  Widget build(BuildContext context) {
    String dropdownValue =
        widget.rating == null ? "-" : widget.rating!.toString();
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        icon:
            const Visibility(visible: false, child: Icon(Icons.arrow_downward)),
        value: dropdownValue,
        elevation: 16,
        onChanged: (String? value) {
          widget.onChanged(value == "-" ? null : value);
        },
        items: itemMap.entries
            .map((e) => e.value)
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: SizedBox(
                width: 20,
                child: value == "-"
                    ? const Icon(Icons.star_border)
                    : Text(
                        value,
                        textAlign: TextAlign.center,
                      )),
          );
        }).toList(),
      ),
    );
  }
}
