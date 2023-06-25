import 'package:flutter/material.dart';
import 'package:dominion_comanion/router/routes.dart' as route;

void main() => runApp(const DominionCompanion());

class DominionCompanion extends StatefulWidget {
  const DominionCompanion({super.key});

  @override
  State<DominionCompanion> createState() => _DominionCompanionState();
}

class _DominionCompanionState extends State<DominionCompanion> {
  @override
  initState() {
    super.initState();
    // ExpansionService().loadJsonExpansionsIntoDB();
  }

  // TODO Gilden-Münzen mit + höhergestellt anzeigen
  // TODO Edit splash screen

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Julias' Dominion Companion",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.orangeAccent,
          secondary: const Color(0xff966a22),
        ),
        scaffoldBackgroundColor: Colors.black,
        dialogBackgroundColor: Colors.white,
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
              iconTheme: const IconThemeData(color: Colors.white),
              titleTextStyle: const TextStyle(
                  fontSize: 20, fontFamily: 'TrajanPro', color: Colors.white),
            ),
        canvasColor: Colors.white,
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'TrajanPro',
              bodyColor: Colors.black,
              displayColor: Colors.black,
            ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.white,
          selectionColor: Colors.white.withOpacity(0.2),
          selectionHandleColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      onGenerateRoute: route.controller,
      initialRoute: route.homePage,
    );
  }
}
