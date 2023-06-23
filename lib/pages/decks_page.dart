import 'dart:developer';

import 'package:dominion_comanion/components/basic_appbar.dart';
import 'package:dominion_comanion/components/button_player_count.dart';
import 'package:dominion_comanion/components/deck_expandable.dart';
import 'package:dominion_comanion/components/custom_alert_dialog.dart';
import 'package:dominion_comanion/components/dropdown_sort.dart';
import 'package:dominion_comanion/components/lazy_scroll_view_decks.dart';
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
  SettingsService settingService = SettingsService();
  DeckService deckService = DeckService();

  // https://docs.flutter.dev/cookbook/navigation/navigate-with-arguments
  // https://www.woolha.com/tutorials/flutter-using-futurebuilder-widget-examples
  @override
  Widget build(BuildContext context) {
    SettingsModel settings = settingService.getCachedSettings();

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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DropdownSort(
                    sortAsc: settings.sortAsc,
                    sortKey: settings.sortKey,
                    onChanged: (asc, key) => {
                      setState(() {
                        settingService.updateCachedSettings(key, asc);
                      })
                    },
                  ),
                  const LazyScrollViewDecks(),
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
