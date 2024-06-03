import 'package:dominion_companion/components/basic_appbar.dart';
import 'package:dominion_companion/components/basic_infobar_bottom.dart';
import 'package:dominion_companion/components/custom_alert_dialog.dart';
import 'package:dominion_companion/components/floating_action_button_coin.dart';
import 'package:dominion_companion/components/lazy_scroll_view_expansion.dart';
import 'package:dominion_companion/router/routes.dart' as route;
import 'package:dominion_companion/services/audio_service.dart';
import 'package:dominion_companion/services/deck_service.dart';
import 'package:dominion_companion/services/temporary_deck_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../services/selected_card_service.dart';

class CreateDeckPage extends StatefulWidget {
  const CreateDeckPage({super.key, this.deckId});

  final int? deckId;

  @override
  State<CreateDeckPage> createState() => _CreateDeckState();
}

class _CreateDeckState extends State<CreateDeckPage> {
  @override
  initState() {
    super.initState();
  }

  final _selectedCardService = SelectedCardService();
  final _deckService = DeckService();
  final _temporaryDeckService = TemporaryDeckService();
  final _audioService = AudioService();

  void onCreateNewDeck(bool random) {
    _audioService.playAudioShuffle();
    _temporaryDeckService.saved = false;
    _temporaryDeckService.createTemporaryDBDeck(
        "", _selectedCardService.selectedCardIds, random);
    Navigator.pushNamed(
      context,
      route.deckInfoPage,
    );
  }

  // https://www.woolha.com/tutorials/flutter-using-futurebuilder-widget-examples
  @override
  Widget build(BuildContext context) {
    _selectedCardService.initializeSelectedCardIds(deckId: widget.deckId);
    final initialCardIds = _selectedCardService.selectedCardIds;
    ValueNotifier<bool> notifier = ValueNotifier(false);
    ValueNotifier<bool> fabExtended = ValueNotifier(false);
    return WillPopScope(
      onWillPop: () async {
        if (widget.deckId == null) {
          return true;
        }
        initialCardIds.sort();
        _selectedCardService.selectedCardIds.sort();
        if (listEquals(initialCardIds, _selectedCardService.selectedCardIds) !=
            true) {
          return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomAlertDialog(
                      title: "Seite verlassen",
                      message: "Seite ohne Speichern verlassen?",
                      onConfirm: () => Navigator.of(context).pop(true));
                },
              ) ??
              false;
        }
        return true;
      },
      child: ValueListenableBuilder(
        valueListenable: DeckService().notifier,
        builder: (BuildContext context, bool val, Widget? child) {
          return Scaffold(
            appBar: BasicAppBar(
                title:
                    widget.deckId == null ? 'Deck erstellen' : 'Deck anpassen'),
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
                Positioned(
                  bottom: 0,
                  child: ValueListenableBuilder(
                    valueListenable: notifier,
                    builder: (BuildContext context, bool val, Widget? child) {
                      return BasicInfoBarBottom(
                          text:
                              "${_selectedCardService.selectedCardIds.length} Karten gewählt");
                    },
                  ),
                )
              ],
            ),
            floatingActionButton: widget.deckId != null
                ? FloatingActionButtonCoin(
                    onPressed: () async => {
                      await _deckService.updateCardIds(
                          widget.deckId!, _selectedCardService.selectedCardIds),
                      Navigator.pop(context)
                    },
                    icon: Icons.save,
                    tooltip: 'Neue Karten speichern',
                  )
                : ValueListenableBuilder(
                    valueListenable: fabExtended,
                    builder: (BuildContext context, bool val, Widget? child) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Visibility(
                            maintainSize: true,
                            maintainAnimation: true,
                            maintainState: true,
                            visible: fabExtended.value,
                            child: Transform.scale(
                              scale: 0.8,
                              child: FloatingActionButtonCoin(
                                onPressed: () async => {
                                  onCreateNewDeck(true),
                                  fabExtended.value = false
                                },
                                icon: Icons.shuffle,
                                tooltip: 'Deck mit zufälligen Karten erstellen',
                              ),
                            ),
                          ),
                          Visibility(
                            maintainSize: true,
                            maintainAnimation: true,
                            maintainState: true,
                            visible: fabExtended.value,
                            child: Transform.scale(
                              scale: 0.8,
                              child: FloatingActionButtonCoin(
                                onPressed: () async => {
                                  onCreateNewDeck(false),
                                  fabExtended.value = false,
                                },
                                icon: Icons.checklist,
                                tooltip:
                                    'Deck mit ausgewählten Karten erstellen',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          FloatingActionButtonCoin(
                            onPressed: () =>
                                fabExtended.value = !fabExtended.value,
                            icon: Icons.play_arrow,
                            tooltip: 'Neues Deck erstellen',
                          ),
                        ],
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}
