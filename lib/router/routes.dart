// https://www.section.io/engineering-education/how-to-handle-navigation-in-flutter/
import 'package:dominion_companion/pages/create_deck_page.dart';
import 'package:dominion_companion/pages/deck_info_page.dart';
import 'package:dominion_companion/pages/decks_page.dart';
import 'package:dominion_companion/pages/home_page.dart';
import 'package:dominion_companion/pages/settings_page.dart';
import 'package:flutter/cupertino.dart';

const String homePage = 'homePage';
const String deckPage = 'deckPage';
const String createDeckPage = 'createDeckPage';
const String deckInfoPage = 'deckInfoPage';
const String settingsPage = 'settingsPage';

// controller function with switch statement to control page route flow
Route<dynamic> controller(RouteSettings settings) {
  switch (settings.name) {
    case homePage:
      return CupertinoPageRoute(builder: (context) => const HomePage());
    case deckPage:
      return CupertinoPageRoute(builder: (context) => const DecksPage());
    case createDeckPage:
      final arguments = (settings.arguments ?? <String, dynamic>{}) as Map;
      return CupertinoPageRoute(
          builder: (context) => CreateDeckPage(deckId: arguments['deckId']));
    case deckInfoPage:
      return CupertinoPageRoute(builder: (context) => const DeckInfoPage());
    case settingsPage:
      return CupertinoPageRoute(builder: (context) => const SettingsPage());
    default:
      throw ('this route name does not exist');
  }
}
