import 'package:dominion_comanion/components/border_button_component.dart';
import 'package:flutter/material.dart';

class CardPopup extends StatefulWidget {
  const CardPopup({
    super.key,
  });

  @override
  State<CardPopup> createState() => _CardPopupState();
}

class _CardPopupState extends State<CardPopup> {
  // https://stackoverflow.com/questions/70529682/create-pop-up-dialog-in-flutter
  // https://daily-dev-tips.com/posts/flutter-3d-pan-effect/

  Offset _offset = Offset.zero;

  updatePan(DragUpdateDetails details) {
    var tempOffset = _offset + details.delta;
    if (tempOffset.dx < 80 &&
        tempOffset.dx > -80 &&
        tempOffset.dy < 40 &&
        tempOffset.dy > -40) {
      _offset += details.delta;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.7,
      heightFactor: 0.9,
      child: Stack(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Center(
                child: Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001) // perspective
                    ..rotateX(0.01 * _offset.dy) // changed
                    ..rotateY(-0.01 * _offset.dx),
                  alignment: FractionalOffset.center,
                  child: GestureDetector(
                    onPanUpdate: (details) =>
                        setState(() => updatePan(details)),
                    onDoubleTap: () => setState(() => _offset = Offset.zero),
                    child: const Image(
                        image: AssetImage('assets/cards/full/torw.png')),
                  ),
                ),
              ),
            ],
          ),
          Align(
              alignment: FractionalOffset.bottomLeft,
              child: BorderButtonComponent(
                  icon: Icons.arrow_back_ios_new,
                  color: 'blue',
                  onClick: () =>
                      Navigator.of(context, rootNavigator: true).pop())),
          Align(
              alignment: FractionalOffset.bottomRight,
              child: BorderButtonComponent(
                  icon: Icons.arrow_forward_ios,
                  color: 'blue',
                  onClick: () =>
                      Navigator.of(context, rootNavigator: true).pop())),
          Align(
              alignment: FractionalOffset.bottomCenter,
              child: BorderButtonComponent(
                  icon: Icons.close,
                  onClick: () =>
                      Navigator.of(context, rootNavigator: true).pop())),
        ],
      ),
    );
  }
}
