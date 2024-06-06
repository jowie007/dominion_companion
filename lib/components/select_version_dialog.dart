
import 'package:dominion_companion/components/basic_dropdown.dart';
import 'package:dominion_companion/services/deck_service.dart';
import 'package:flutter/material.dart';

class SelectVersionDialog extends StatefulWidget {
  const SelectVersionDialog(
      {Key? key,
      required this.onSaved,
      required this.currentVersion,
      required this.availableVersions})
      : super(key: key);

  final void Function(String deckName) onSaved;
  final String currentVersion;
  final Map<String, String> availableVersions;

  @override
  State<SelectVersionDialog> createState() => _SelectVersionDialogState();
}

class _SelectVersionDialogState extends State<SelectVersionDialog> {
  late String selectedVersion;

  @override
  void initState() {
    super.initState();
    selectedVersion = widget.currentVersion;
  }

  @override
  Widget build(BuildContext context) {
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
                              child: BasicDropdown(
                                selected: selectedVersion,
                                available: widget.availableVersions,
                                onChanged: (newVersion) => {
                                  setState(() => selectedVersion = newVersion!)
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
                                    widget.onSaved(selectedVersion);
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
