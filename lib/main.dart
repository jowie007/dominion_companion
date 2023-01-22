import 'package:dominion_comanion/services/expansion_service.dart';
import 'package:dominion_comanion/services/json_service.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    ExpansionService().loadJsonExpansionsIntoDB();
    return MaterialApp(
      title: 'Connect Page',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.orangeAccent,
          secondary: Colors.deepPurple,
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.white,
          selectionColor: Colors.white.withOpacity(0.2),
          selectionHandleColor: Colors.white,
        ),
      ),
      onGenerateRoute: route.controller,
      initialRoute: route.homePage,
    );
  }
}
