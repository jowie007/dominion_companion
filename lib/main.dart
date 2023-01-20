import 'package:dominion_comanion/services/json_service.dart';
import 'package:flutter/material.dart';
import 'package:dominion_comanion/router/routes.dart' as route;

void main() => runApp(const DominionCompanion());

class DominionCompanion extends StatelessWidget {
  const DominionCompanion({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connect Page',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.orangeAccent,
          secondary: Colors.deepPurple,),
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