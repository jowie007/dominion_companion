import 'dart:developer';

import 'package:dominion_comanion/components/basic_appbar.dart';
import 'package:dominion_comanion/components/button_player_count.dart';
import 'package:dominion_comanion/components/deck_expandable.dart';
import 'package:dominion_comanion/components/dropdown_menu.dart';
import 'package:dominion_comanion/components/floating_action_button_coin.dart';
import 'package:dominion_comanion/components/name_deck_dialog.dart';
import 'package:dominion_comanion/model/settings/settings_model.dart';
import 'package:dominion_comanion/services/deck_service.dart';
import 'package:dominion_comanion/router/routes.dart' as route;
import 'package:dominion_comanion/services/settings_service.dart';
import 'package:flutter/material.dart';

class DecksPage extends StatefulWidget {
  const DecksPage({super.key});

  @override
  State<DecksPage> createState() => _DecksState();
}

class _DecksState extends State<DecksPage> {
  late DeckService _deckService;

  @override
  initState() {
    super.initState();
    _deckService = DeckService();
  }

  // TODO In Futurebuilder auslagern
  SettingsModel settings = SettingsService().getCachedSettings();

  // https://docs.flutter.dev/cookbook/navigation/navigate-with-arguments
  // https://www.woolha.com/tutorials/flutter-using-futurebuilder-widget-examples
  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> fabExtended = ValueNotifier(false);
    _deckService.initializeChangeNotify();
    return ValueListenableBuilder(
      valueListenable: _deckService.changeNotify,
      builder: (BuildContext context, bool val, Widget? child) {
        return Scaffold(
          appBar: const BasicAppBar(title: 'Decks'),
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
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
                  child: Column(
                    children: [
                      FutureBuilder(
                        future: _deckService.getDeckList(
                            sortAsc: settings.sortAsc, sortKey: settings.sortKey),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                CircularProgressIndicator(),
                              ],
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasError) {
                              throw Exception(snapshot.error);
                            } else if (snapshot.hasData) {
                              return snapshot.data != null &&
                                      snapshot.data!.isNotEmpty
                                  ? Expanded(
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: <Widget>[
                                            DropdownMenu(
                                              sortAsc: settings.sortAsc,
                                              sortKey: settings.sortKey,
                                              onChanged: (asc, key) => {
                                                setState(() {
                                                  SettingsService().setCachedSettingsSortAsc(asc);
                                                  SettingsService().setCachedSettingsSortKey(key);
                                                })
                                              },
                                            ),
                                            ListView.builder(
                                              // padding: const EdgeInsets.all(8),
                                              physics:
                                                  const ClampingScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: snapshot.data!.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                final item =
                                                    snapshot.data![index];
                                                // https://stackoverflow.com/questions/57542470/how-to-fix-this-dismissible-widget-border
                                                return ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                  child: Dismissible(
                                                    key: Key(item.name),
                                                    background: Container(
                                                        color: Colors.red),
                                                    secondaryBackground:
                                                        Container(
                                                            color:
                                                                Colors.green),
                                                    direction: DismissDirection
                                                        .horizontal,
                                                    onDismissed: (direction) {
                                                      setState(() {
                                                        if (direction ==
                                                            DismissDirection
                                                                .startToEnd) {
                                                          _deckService
                                                              .deleteDeckByName(
                                                                  item.name);
                                                        }
                                                      });
                                                      // Then show a snackbar.
                                                      /*ScaffoldMessenger.of(
                                                          context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              '$item dismissed')));*/
                                                    },
                                                    child: DeckExpandable(
                                                      deckModel: item,
                                                      onLongPress: () =>
                                                          showDialog<String>(
                                                        context: context,
                                                        useRootNavigator: false,
                                                        builder: (BuildContext
                                                                innerContext) =>
                                                            NameDeckDialog(
                                                          oldName: item.name,
                                                          onSaved: (deckName) =>
                                                              setState(
                                                            () {
                                                              _deckService
                                                                  .renameDeck(
                                                                      item.name,
                                                                      deckName);
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : const Text('Keine Decks gefunden');
                            } else {
                              return const Text('Keine Decks gefunden');
                            }
                          } else {
                            return Text('State: ${snapshot.connectionState}');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const Positioned(
                  bottom: 22, left: 22, child: ButtonPlayerCount()),
            ],
          ),
          floatingActionButton: ValueListenableBuilder(
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
                        onPressed: () => {
                          Navigator.pushNamed(context, route.createDeckPage,
                              arguments: {"random": "true"}),
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
                        onPressed: () => {
                          Navigator.pushNamed(
                            context,
                            route.createDeckPage,
                          ),
                          fabExtended.value = false,
                        },
                        icon: Icons.checklist,
                        tooltip: 'Deck mit ausgewählten Karten erstellen',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  FloatingActionButtonCoin(
                    onPressed: () => fabExtended.value = !fabExtended.value,
                    icon: Icons.play_arrow,
                    tooltip: 'Neues Deck erstellen',
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
