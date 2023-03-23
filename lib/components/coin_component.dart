import 'dart:developer';

import 'package:flutter/material.dart';

class CostComponent extends StatelessWidget {
  const CostComponent(
      {Key? key, required this.width, required this.type, this.value})
      : super(key: key);

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
        Image(
          width: width,
          image: AssetImage('assets/cards/other/$type.png'),
        ),
        value != null && splitValuePlus.isNotEmpty
            ? Container(
                padding: const EdgeInsets.fromLTRB(2, 5, 0, 0),
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(splitValuePlus[0].toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 30)),
                    splitValuePlus.length > 1
                        ? const Text("+",
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 20))
                        : Container()
                  ],
                ),
              )
            : Container(),
      ],
    );
  }
}
