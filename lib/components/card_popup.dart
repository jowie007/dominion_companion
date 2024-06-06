import 'dart:async';

import 'package:dominion_companion/components/border_button_component.dart';
import 'package:dominion_companion/components/custom_alert_dialog.dart';
import 'package:dominion_companion/model/settings/settings_model.dart';
import 'package:dominion_companion/services/file_service.dart';
import 'package:dominion_companion/services/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

import 'package:sensors_plus/sensors_plus.dart';

class CardPopup extends StatefulWidget {
  const CardPopup(
      {super.key,
      required this.cardIds,
      this.expansionId = "",
      this.error = false});

  final List<String> cardIds;
  final String expansionId;
  final bool error;

  @override
  State<CardPopup> createState() => _CardPopupState();
}

class _CardPopupState extends State<CardPopup> {
  // https://stackoverflow.com/questions/70529682/create-pop-up-dialog-in-flutter
  // https://daily-dev-tips.com/posts/flutter-3d-pan-effect/
  SettingsModel settings = SettingsService().getCachedSettings();
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  final _fileService = FileService();
  Offset _offset = Offset.zero;
  int _selectedCardPosition = 0;
  late String _cardPath;

  updatePan(DragUpdateDetails details) {
    var tempOffset = _offset + details.delta;
    if (tempOffset.dx < 80 &&
        tempOffset.dx > -80 &&
        tempOffset.dy < 40 &&
        tempOffset.dy > -40) {
      _offset += details.delta;
    }
  }

  updateCardPath() {
    _cardPath =
        'assets/cards/full/${widget.cardIds[_selectedCardPosition].split("-")[0]}/${widget.cardIds[_selectedCardPosition].split("-")[2]}.png';
  }

  previousCard() {
    _selectedCardPosition = _selectedCardPosition > 0
        ? _selectedCardPosition - 1
        : widget.cardIds.length - 1;
    updateCardPath();
  }

  nextCard() {
    _selectedCardPosition = _selectedCardPosition == widget.cardIds.length - 1
        ? 0
        : _selectedCardPosition + 1;
    updateCardPath();
  }

  Future<Map<String, int>> getImageDimensions() async {
    ByteData imageData = await rootBundle.load(_cardPath);
    Uint8List bytes = imageData.buffer.asUint8List();
    ui.Codec codec = await ui.instantiateImageCodec(bytes);
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    ui.Image image = frameInfo.image;

    final int width = image.width;
    final int height = image.height;

    Map<String, int> dimensions = {
      'width': width,
      'height': height,
    };
    return dimensions;
  }

  @override
  void initState() {
    super.initState();
    if (settings.gyroscopeCardPopup) {
      gyroscopeEventStream().listen(
        (GyroscopeEvent event) {
          try {
            setState(() {
              var tempOffset = _offset + Offset(-event.y * 16, -event.x * 16);
              if (tempOffset.dx < 80 &&
                  tempOffset.dx > -80 &&
                  tempOffset.dy < 40 &&
                  tempOffset.dy > -40) {
                _offset = tempOffset;
              }
            });
          } catch (_) {}
        },
        onError: (error) {},
        cancelOnError: true,
      );
    }
  }

  @override
  void dispose() {
    _gyroscopeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var error = widget.error;
    try {
      updateCardPath();
    } catch (_) {
      error = true;
    }
    if (error) {
      return const CustomAlertDialog(
        title: "Fehler",
        message: "Karte konnte nicht geladen werden",
        onlyCancelButton: true,
      );
    }
    return FutureBuilder(
      future: Future.wait([
        getImageDimensions(),
        _fileService.checkForExpansionsInstructions(widget.expansionId)
      ]),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          var imageDimensions = snapshot.data![0] as Map<String, int>;
          var instructionExists = snapshot.data![1] as bool;
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: Stack(
              children: [
                Center(
                  child: FractionallySizedBox(
                    widthFactor: 0.7,
                    heightFactor: 0.9,
                    child: Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001) // perspective
                        ..rotateX(0.01 * _offset.dy) // changed
                        ..rotateY(-0.01 * _offset.dx),
                      alignment: FractionalOffset.center,
                      child: GestureDetector(
                        onPanUpdate: (details) => setState(() => {
                              if (!settings.gyroscopeCardPopup)
                                {updatePan(details)}
                            }),
                        onDoubleTap: () =>
                            setState(() => _offset = Offset.zero),
                        child: FittedBox(
                          child: SizedBox(
                            width: imageDimensions["width"]!.toDouble(),
                            height: imageDimensions["height"]!.toDouble(),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(28.0),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    4.0, 0.0, 0.0, 0.0),
                                child: Image.asset(
                                  _cardPath,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                widget.cardIds.length > 1
                    ? Align(
                        alignment: FractionalOffset.bottomLeft,
                        child: BorderButtonComponent(
                          icon: Icons.arrow_back_ios_new,
                          color: 'blue',
                          onClick: () => setState(
                            () => previousCard(),
                          ),
                        ),
                      )
                    : Container(),
                widget.cardIds.length > 1
                    ? Align(
                        alignment: FractionalOffset.bottomRight,
                        child: BorderButtonComponent(
                          icon: Icons.arrow_forward_ios,
                          color: 'blue',
                          onClick: () => setState(
                            () => nextCard(),
                          ),
                        ),
                      )
                    : Container(),
                OrientationBuilder(
                  builder: (context, orientation) {
                    return Align(
                        alignment: orientation == Orientation.portrait
                            ? FractionalOffset.bottomCenter
                            : FractionalOffset.topLeft,
                        child: BorderButtonComponent(
                            icon: Icons.close,
                            onClick: () =>
                                Navigator.of(context, rootNavigator: true)
                                    .pop()));
                  },
                ),
                widget.expansionId != "" && instructionExists
                    ? Align(
                        alignment: FractionalOffset.topRight,
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 12, 7, 0),
                            child: BorderButtonComponent(
                                icon: Icons.description_outlined,
                                color: 'green',
                                width: 60,
                                /*onClick: () => showDialog(
                    context: context,
                    builder: (context) {
                      return InstructionsPopup(expansionId: widget.expansionId);
                    },
                  ),*/
                                onClick: () async {
                                  _fileService.openExpansionInstructions(
                                      widget.expansionId);
                                })))
                    : Container(),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
