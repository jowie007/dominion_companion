import 'package:dominion_comanion/components/basic_appbar.dart';
import 'package:dominion_comanion/components/basic_infobar_bottom.dart';
import 'package:dominion_comanion/components/expansion_expandable.dart';
import 'package:dominion_comanion/components/floating_action_button_coin.dart';
import 'package:dominion_comanion/model/deck/deck_model.dart';
import 'package:dominion_comanion/services/expansion_service.dart';
import 'package:flutter/material.dart';
import 'package:dominion_comanion/router/routes.dart' as route;

import '../services/selected_card_service.dart';

class DeckInfoPage extends StatefulWidget {
  const DeckInfoPage({super.key});

  @override
  State<DeckInfoPage> createState() => _DeckInfoState();
}

class _DeckInfoState extends State<DeckInfoPage> {
  @override
  initState() {
    super.initState();
  }

  final _selectedCardService = SelectedCardService();

  // https://www.woolha.com/tutorials/flutter-using-futurebuilder-widget-examples
  @override
  Widget build(BuildContext context) {
    final deck = ModalRoute.of(context)!.settings.arguments as DeckModel;
    _selectedCardService.initializeSelectedCardIds();
    ValueNotifier<bool> notifier = ValueNotifier(false);
    return Scaffold(
      appBar: const BasicAppBar(title: 'Deck Info'),
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
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 64),
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
            ],
          ),
          Positioned(
            bottom: 0,
            child: ValueListenableBuilder(
              valueListenable: notifier,
              builder: (BuildContext context, bool val, Widget? child) {
                return BasicInfoBarBottom(
                    text:
                    "${_selectedCardService.selectedCardIds.length}/20+");
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButtonCoin(
        icon: Icons.play_arrow,
        tooltip: "Deck erzeugen",
        onPressed: () => Navigator.pushNamed(context, route.createDeckPage),
      ),
    );
  }
}
