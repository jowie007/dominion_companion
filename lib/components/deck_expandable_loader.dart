import 'dart:developer';

import 'package:dominion_comanion/components/deck_expandable.dart';
import 'package:dominion_comanion/model/deck/deck_model.dart';
import 'package:flutter/material.dart';

class DeckExpandableLoader extends StatelessWidget {
  const DeckExpandableLoader(
      {super.key,
      required this.futureDeckModel,
      this.onLoaded,
      this.initiallyExpanded = false,
      this.isNewlyCreated = false,
      this.onLongPress});

  final Future<DeckModel> futureDeckModel;

  final void Function(DeckModel deckModel)? onLoaded;
  final bool initiallyExpanded;
  final bool isNewlyCreated;
  final void Function()? onLongPress;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureDeckModel,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              Visibility(
                visible: snapshot.hasData,
                child: const Text(
                  "Warte auf Deck",
                  style: TextStyle(color: Colors.black, fontSize: 24),
                ),
              )
            ],
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            throw Exception(snapshot.error);
            return Text(snapshot.error.toString());
          } else if (snapshot.hasData) {
            if (snapshot.data != null && onLoaded != null) {
              onLoaded!(snapshot.data!);
            }
            return snapshot.data != null
                ? DeckExpandable(
                    deckModel: snapshot.data!,
                    initiallyExpanded: initiallyExpanded,
                    isNewlyCreated: isNewlyCreated,
                  )
                : const Text('Deck konnte nicht geladen werden');
          } else {
            return const Text('Deck konnte nicht geladen werden');
          }
        } else {
          return Text('State: ${snapshot.connectionState}');
        }
      },
    );
  }
}
