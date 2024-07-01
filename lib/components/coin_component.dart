import 'package:flutter/material.dart';

class CostComponent extends StatelessWidget {
  const CostComponent(
      {super.key, required this.width, required this.type, this.value});

  final double width;
  final String type;
  final String? value;

  @override
  Widget build(BuildContext context) {
    var splitValuePlus = [];
    if (value != null) {
      splitValuePlus = value!.split("+");
    }
    return Stack(
      children: [
        type == 'potion'
            ? Image(
                width: width,
                image: const AssetImage('assets/cards/other/potion.png'),
              )
            : Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/cards/other/$type.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
                width: width,
                // Adjusted for two digit numbers
                padding: type != 'debt'
                    ? EdgeInsets.fromLTRB(
                        splitValuePlus[0].toString().length > 1 ? 0 : 2,
                        5,
                        0,
                        0)
                    : const EdgeInsets.fromLTRB(1, 5, 0, 0),
                child: value != null && splitValuePlus.isNotEmpty
                    ? FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              splitValuePlus[0].toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 30,
                                  letterSpacing:
                                      splitValuePlus[0].toString().length > 1
                                          ? -3
                                          : 0,
                                  color: type == 'coin'
                                      ? Colors.black
                                      : Colors.white),
                            ),
                            splitValuePlus.length > 1
                                ? Text("+",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: type == 'coin'
                                            ? Colors.black
                                            : Colors.white))
                                : Container()
                          ],
                        ),
                      )
                    : Container(),
              )
      ],
    );
  }
}
