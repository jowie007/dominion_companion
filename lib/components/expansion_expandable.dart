import 'dart:developer';

import 'package:dominion_comanion/components/round_checkbox.dart';
import 'package:flutter/material.dart';

class ExpansionExpandable extends StatefulWidget {
  const ExpansionExpandable({super.key});

  @override
  State<ExpansionExpandable> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<ExpansionExpandable> {
  dynamic _allSelected = false;

  void _onCheckboxChanged(bool? newValue) => setState(() {
        if (_allSelected == null) {
          _allSelected = false;
        } else {
          _allSelected = !_allSelected;
        }
      });

  // https://stackoverflow.com/questions/53908025/flutter-sortable-drag-and-drop-listview

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Stack(
                  children: [
                    Container(
                      width: 400,
                      height: 56,
                      child: Image.asset(
                        "assets/boxart/adventures.webp",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: ExpansionTile(
                        title: const Text('ExpansionTile 1',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(1.0, 1.0),
                                  blurRadius: 1.0,
                                  color: Colors.black,
                                ),
                                Shadow(
                                  offset: Offset(1.0, 1.0),
                                  blurRadius: 2.0,
                                  color: Colors.black,
                                ),
                              ],
                            )),
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                //I assumed you want to occupy the entire space of the card
                                image: AssetImage(
                                  "assets/cards/types/small/treasure-victory.png",
                                ),
                              ),
                            ),
                            child: CheckboxListTile(
                              title: Text('This is tile number 1'),
                              subtitle: Text('This is tile number 2'),
                              tileColor: Colors.white,
                              value: true,
                              onChanged: (bool? value) {
                                log(value.toString());
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0.0,
              top: 0.0,
              child: RoundCheckbox(
                onChanged: _onCheckboxChanged,
                value: _allSelected,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
