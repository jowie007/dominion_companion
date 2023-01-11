// https://www.section.io/engineering-education/how-to-handle-navigation-in-flutter/
import 'package:dominion_comanion/pages/deck_page.dart';
import 'package:dominion_comanion/pages/home_page.dart';
import 'package:flutter/cupertino.dart';

const String homePage = 'homePage';
const String deckPage = 'deckPage';

// controller function with switch statement to control page route flow
Route<dynamic> controller(RouteSettings settings) {
  switch (settings.name) {
    case homePage:
      return CupertinoPageRoute(builder: (context) => const HomePage());
    case deckPage:
      return CupertinoPageRoute(builder: (context) => const DeckPage());
    default:
      throw ('this route name does not exist');
  }
}