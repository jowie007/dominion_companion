import 'package:dominion_companion/components/dropdown_expansion_version.dart';
import 'package:dominion_companion/services/deck_service.dart';
import 'package:flutter/material.dart';

class SelectVersionDialog extends StatelessWidget {
  const SelectVersionDialog(
      {super.key,
      required this.onSaved,
      required this.currentVersion,
      required this.availableVersions});

  final void Function(String deckName) onSaved;
  final String currentVersion;
  final List<String> availableVersions;

  @override
  Widget build(BuildContext context) {
    final TextEditingController deckNameController =
        TextEditingController(text: currentVersion);
    final deckService = DeckService();

    return FutureBuilder(
      future: deckService.getAllDeckNames(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: CircularProgressIndicator()),
            ],
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            throw Exception(snapshot.error);
          } else if (snapshot.hasData) {
            return snapshot.data != null
                ? Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(
                              height: 10,
                            ),
                            const Text('Version auswählen'),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 28, vertical: 10),
                              child: DropdownExpansionVersion(
                                currentVersion: currentVersion,
                                availableVersions: availableVersions,
                                onChanged: (newVersion) => {
                                  /*setState(() {
                                    settingService.updateCachedSettings(
                                        key, asc);
                                  })*/
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Abbrechen'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    onSaved(deckNameController.text.toString());
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Speichern'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : const Text('Version kann momentan nicht geändert werden');
          } else {
            return const Text('Version kann momentan nicht geändert werden');
          }
        } else {
          return Text('State: ${snapshot.connectionState}');
        }
      },
    );
  }
}
