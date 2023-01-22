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
                padding: EdgeInsets.fromLTRB(width * 0.28, width * 0.14, 0, 0),
                child: Text(value.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'TrajanPro', fontSize: width * 0.75)),
              )
            : Container(),
      ],
    );
  }
}
