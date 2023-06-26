import 'package:dominion_comanion/components/custom_alert_dialog.dart';
import 'package:dominion_comanion/services/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:dominion_comanion/router/routes.dart' as route;
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const DominionCompanion());
  final settingsService = SettingsService();
  try {
    await settingsService.initializeApp();
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

  // TODO Gilden-Münzen mit + höhergestellt anzeigen
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
