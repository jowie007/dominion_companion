import 'package:dominion_comanion/components/basic_appbar.dart';
import 'package:dominion_comanion/components/expansion_expandable.dart';
import 'package:dominion_comanion/model/card/card_cost_model.dart';
import 'package:dominion_comanion/model/card/card_model.dart';
import 'package:dominion_comanion/model/card/card_type_enum.dart';
import 'package:dominion_comanion/services/expansion_service.dart';
import 'package:flutter/material.dart';

import '../services/selected_card_service.dart';

class CreateDeckPage extends StatefulWidget {
  const CreateDeckPage({super.key});

  @override
  State<CreateDeckPage> createState() => _CreateDeckState();
}

class _CreateDeckState extends State<CreateDeckPage> {
  @override
  initState() {
    super.initState();
  }

  final _selectedCardService = SelectedCardService();

  // https://www.woolha.com/tutorials/flutter-using-futurebuilder-widget-examples
  @override
  Widget build(BuildContext context) {
    _selectedCardService.initializeSelectedCardIds();
    return Scaffold(
      appBar: const BasicAppBar(title: 'Deck erstellen'),
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
          SingleChildScrollView(
            child: FutureBuilder(
              future: ExpansionService().loadAllExpansions(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      Visibility(
                        visible: snapshot.hasData,
                        child: const Text(
                          "Warte auf Erweiterungen",
                          style: TextStyle(color: Colors.black, fontSize: 24),
                        ),
                      )
                    ],
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else if (snapshot.hasData) {
                    return snapshot.data != null && snapshot.data!.isNotEmpty
                        ? Column(children: [
                            for (var expansion in snapshot.data!)
                              ExpansionExpandable(
                                  imagePath: expansion.id,
                                  title: [expansion.name, expansion.version]
                                      .join(" - "),
                                  cards: expansion.cards,
                                  selectedCardService: _selectedCardService)
                          ])
                        : const Text('Keine Erweiterungen gefunden');
                  } else {
                    return const Text('Keine Erweiterungen gefunden');
                  }
                } else {
                  return Text('State: ${snapshot.connectionState}');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
