import 'package:dominion_companion/router/routes.dart' as route;
import 'package:dominion_companion/services/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

// TODO Add licence
// TODO Dont delete databases
// TODO Fix verbuendete card hardcoding
// TODO Add a setting to configure your sets
// TODO Add a setting to show only one version of expansion (the other is stacked)
// TODO Make background configurable
Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const DominionCompanion());
  final settingsService = SettingsService();
  try {
    await settingsService.initializeApp(
        checkCardNamesAndImages: false,
        initializeExpansions: false,
        deleteDecks: false,
        deleteSettings: false);
    FlutterNativeSplash.remove();
  } on Exception catch (e) {
    settingsService.initException = e;
    FlutterNativeSplash.remove();
  }
}

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
              backgroundColor: Colors.orangeAccent,
              iconTheme: const IconThemeData(color: Colors.white),
              titleTextStyle: const TextStyle(
                  fontSize: 20, fontFamily: 'TrajanPro', color: Colors.white),
            ),
        canvasColor: Colors.white,
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orangeAccent),
          ),
          border: OutlineInputBorder(),
        ),
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'TrajanPro',
              bodyColor: Colors.black,
              displayColor: Colors.black,
            ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.orangeAccent,
          selectionHandleColor: Colors.orangeAccent,
        ),
        useMaterial3: true,
      ),
      onGenerateRoute: route.controller,
      initialRoute: route.homePage,
    );
  }
}
