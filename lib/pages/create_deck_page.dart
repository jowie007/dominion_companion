import 'dart:developer';

import 'package:dominion_comanion/components/basic_appbar.dart';
import 'package:dominion_comanion/components/basic_infobar.dart';
import 'package:dominion_comanion/components/expansion_expandable.dart';
import 'package:dominion_comanion/model/card/card_cost_model.dart';
import 'package:dominion_comanion/model/card/card_model.dart';
import 'package:dominion_comanion/model/card/card_type_enum.dart';
import 'package:dominion_comanion/services/expansion_service.dart';
import 'package:flutter/material.dart';

import '../services/selected_card_service.dart';

class CreateDeckPage extends StatefulWidget {
  const CreateDeckPage({super.key});

  @override
  State<CreateDeckPage> createState() => _CreateDeckState();
}

class _CreateDeckState extends State<CreateDeckPage> {
  @override
  initState() {
    super.initState();
  }

  final _selectedCardService = SelectedCardService();

  // https://www.woolha.com/tutorials/flutter-using-futurebuilder-widget-examples
  @override
  Widget build(BuildContext context) {
    _selectedCardService.initializeSelectedCardIds();
    var topBarText = "${_selectedCardService.selectedCardIds.length}/20+";
    ValueNotifier<bool> notifier = ValueNotifier(false);
    return Scaffold(
      appBar: const BasicAppBar(title: 'Deck erstellen'),
      /* bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {},
          child: Text('Create Deck'),
        ),
      ),*/
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/menu/main_scroll_crop.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 36, 0, 0),
                    child: FutureBuilder(
                      future: ExpansionService().loadAllExpansions(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(),
                              Visibility(
                                visible: snapshot.hasData,
                                child: const Text(
                                  "Warte auf Erweiterungen",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 24),
                                ),
                              )
                            ],
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          } else if (snapshot.hasData) {
                            return snapshot.data != null &&
                                    snapshot.data!.isNotEmpty
                                ? Column(
                                    children: [
                                      for (var expansion in snapshot.data!)
                                        ExpansionExpandable(
                                            imagePath: expansion.id,
                                            title: [
                                              expansion.name,
                                              expansion.version
                                            ].join(" - "),
                                            cards: expansion.cards,
                                            selectedCardService:
                                                _selectedCardService,
                                            onChanged: () => notifier.value =
                                                !notifier.value),
                                    ],
                                  )
                                : const Text('Keine Erweiterungen gefunden');
                          } else {
                            return const Text('Keine Erweiterungen gefunden');
                          }
                        } else {
                          return Text('State: ${snapshot.connectionState}');
                        }
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                child: ValueListenableBuilder(
                    valueListenable: notifier,
                    builder: (BuildContext context, bool val, Widget? child) {
                      return BasicInfoBar(
                          text:
                              "${_selectedCardService.selectedCardIds.length}/20+");
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
