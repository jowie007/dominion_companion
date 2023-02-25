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
    return Stack(
      children: [
        Image(
          width: width,
          image: AssetImage('assets/cards/other/$type.png'),
        ),
        value != null
            ? Container(
                padding: const EdgeInsets.fromLTRB(2, 5, 0, 0),
                width: width,
                child: Text(value.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 30)),
              )
            : Container(),
      ],
    );
  }
}
