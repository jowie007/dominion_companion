import 'package:dominion_comanion/components/basic_appbar.dart';
import 'package:dominion_comanion/components/button_player_count.dart';
import 'package:dominion_comanion/components/deck_expandable.dart';
import 'package:dominion_comanion/components/custom_alert_dialog.dart';
import 'package:dominion_comanion/components/dropdown_sort.dart';
import 'package:dominion_comanion/components/name_deck_dialog.dart';
import 'package:dominion_comanion/model/settings/settings_model.dart';
import 'package:dominion_comanion/services/deck_service.dart';
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

  SettingsModel settings = SettingsService().getCachedSettings();

  // https://docs.flutter.dev/cookbook/navigation/navigate-with-arguments
  // https://www.woolha.com/tutorials/flutter-using-futurebuilder-widget-examples
  @override
  Widget build(BuildContext context) {
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
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                                        DropdownSort(
                                          sortAsc: settings.sortAsc,
                                          sortKey: settings.sortKey,
                                          onChanged: (asc, key) => {
                                            setState(() {
                                              SettingsService()
                                                  .setCachedSettingsSortAsc(
                                                      asc);
                                              SettingsService()
                                                  .setCachedSettingsSortKey(
                                                      key);
                                            })
                                          },
                                        ),
                                        ListView.builder(
                                          // padding: const EdgeInsets.all(8),
                                          physics:
                                              const ClampingScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: snapshot.data!.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final item = snapshot.data![index];
                                            // https://stackoverflow.com/questions/57542470/how-to-fix-this-dismissible-widget-border
                                            return ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              child: Dismissible(
                                                key: Key(item.name),
                                                background: const Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                20, 35, 0, 0),
                                                        child:
                                                            Icon(Icons.delete)),
                                                  ],
                                                ),
                                                secondaryBackground: const Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                0, 35, 20, 0),
                                                        child:
                                                            Icon(Icons.edit)),
                                                  ],
                                                ),
                                                direction:
                                                    DismissDirection.horizontal,
                                                confirmDismiss:
                                                    (direction) async {
                                                  if (direction ==
                                                      DismissDirection
                                                          .startToEnd) {
                                                    return await showDialog<
                                                        bool>(
                                                      context: context,
                                                      builder: (context) {
                                                        return const CustomAlertDialog(
                                                          title: "Löschen",
                                                          message:
                                                              "Soll das Deck wirklich gelöscht werden?",
                                                        );
                                                      },
                                                    );
                                                  }
                                                  if (direction ==
                                                      DismissDirection
                                                          .endToStart) {
                                                    return await showDialog<
                                                        bool>(
                                                      context: context,
                                                      builder: (context) {
                                                        return const CustomAlertDialog(
                                                          title: "Bearbeiten",
                                                          message:
                                                              "Sollen die enthaltenen Karten angepasst werden?",
                                                        );
                                                      },
                                                    );
                                                  }
                                                  return false;
                                                },
                                                onDismissed: (direction) {
                                                  if (direction ==
                                                      DismissDirection
                                                          .startToEnd) {
                                                    setState(() {
                                                      _deckService
                                                          .deleteDeckByName(
                                                              item.name);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              const SnackBar(
                                                                  content: Text(
                                                                      "Deck wurde gelöscht")));
                                                    });
                                                    if (direction ==
                                                        DismissDirection
                                                            .endToStart) {
                                                      // TODO Karten austauschen
                                                    }
                                                  }
                                                },
                                                // TODO LazyList einfügen
                                                // TODO Wrapper in DeckExpandable auslagern
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
                                                                  item.id!,
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
          const Align(
            alignment: FractionalOffset.bottomCenter,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: ButtonPlayerCount(),
            ),
          ),
        ],
      ),
    );
  }
}