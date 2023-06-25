/*import 'package:dominion_comanion/components/border_button_component.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class InstructionsPopup extends StatefulWidget {
  const InstructionsPopup({super.key, required this.expansionId});

  final String expansionId;

  @override
  State<InstructionsPopup> createState() => _InstructionsPopupState();
}

class _InstructionsPopupState extends State<InstructionsPopup> {
  @override
  Widget build(BuildContext context) {
    final pdfPinchController = PdfControllerPinch(
      document: PdfDocument.openAsset(
          'assets/instructions/${widget.expansionId}.pdf'),
    );
    return Stack(children: [
      PdfViewPinch(
        controller: pdfPinchController,
      ),
      /*Align(
          alignment: FractionalOffset.bottomCenter,
          child: BorderButtonComponent(
              icon: Icons.close,
              onClick: () => Navigator.of(context, rootNavigator: true).pop())),*/
    ]);
  }
}
*/