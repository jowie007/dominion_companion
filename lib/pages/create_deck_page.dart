import 'package:dominion_comanion/components/basic_appbar.dart';
import 'package:dominion_comanion/components/basic_infobar_bottom.dart';
import 'package:dominion_comanion/components/expansion_expandable.dart';
import 'package:dominion_comanion/components/floating_action_button_coin.dart';
import 'package:dominion_comanion/components/lazy_scroll_view_expansion.dart';
import 'package:dominion_comanion/services/deck_service.dart';
import 'package:dominion_comanion/services/expansion_service.dart';
import 'package:dominion_comanion/services/temporary_deck_service.dart';
import 'package:flutter/material.dart';
import 'package:dominion_comanion/router/routes.dart' as route;

import '../services/selected_card_service.dart';

class CreateDeckPage extends StatefulWidget {
  const CreateDeckPage({super.key, this.random = false});

  final bool random;

  @override
  State<CreateDeckPage> createState() => _CreateDeckState();
}

class _CreateDeckState extends State<CreateDeckPage> {
  @override
  initState() {
    super.initState();
  }

  final _selectedCardService = SelectedCardService();
  final _temporaryDeckService = TemporaryDeckService();

  // https://www.woolha.com/tutorials/flutter-using-futurebuilder-widget-examples
  @override
  Widget build(BuildContext context) {
    _selectedCardService.initializeSelectedCardIds();
    ValueNotifier<bool> notifier = ValueNotifier(false);
    return Scaffold(
      appBar: const BasicAppBar(title: 'Deck erstellen'),
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
          LazyScrollViewExpansions(
              onChanged: () => notifier.value = !notifier.value),
          widget.random
              ? Positioned(
                  bottom: 0,
                  child: ValueListenableBuilder(
                    valueListenable: notifier,
                    builder: (BuildContext context, bool val, Widget? child) {
                      return BasicInfoBarBottom(
                          text:
                              "${_selectedCardService.selectedCardIds.length}/${DeckService.deckSize}+");
                    },
                  ),
                )
              : Container(),
        ],
      ),
      floatingActionButton: FloatingActionButtonCoin(
        icon: Icons.play_arrow,
        tooltip: "Deck erstellen",
        onPressed: () async => {
          _temporaryDeckService.saved = false,
          _temporaryDeckService.createTemporaryDBDeck(
              "", _selectedCardService.selectedCardIds, widget.random),
          Navigator.pushNamed(
            context,
            route.deckInfoPage,
          ),
        },
      ),
    );
  }
}
