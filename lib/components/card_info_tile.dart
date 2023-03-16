import 'package:dominion_comanion/components/card_popup.dart';
import 'package:dominion_comanion/components/coin_component.dart';
import 'package:dominion_comanion/components/round_checkbox.dart';
import 'package:dominion_comanion/components/expansion_icon.dart';
import 'package:dominion_comanion/model/card/card_model.dart';
import 'package:dominion_comanion/services/card_service.dart';
import 'package:dominion_comanion/services/player_service.dart';
import 'package:flutter/material.dart';

class CardInfoTile extends StatefulWidget {
  const CardInfoTile({
    super.key,
    required this.card,
    required this.onChanged,
    required this.value,
    this.hasCheckbox = true,
  });

  final void Function(bool? value) onChanged;
  final CardModel card;
  final bool value;
  final bool hasCheckbox;

  @override
  State<CardInfoTile> createState() => _CardInfoTileState();
}

class _CardInfoTileState extends State<CardInfoTile> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final newCheckBoxTheme = theme.checkboxTheme.copyWith(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
    );
    final CardService cardService = CardService();
    final cardTypeString = CardModel.getCardTypesString(widget.card.cardTypes);
    final cardColors = cardService.getColorsByCardTypeString(cardTypeString);
    final PlayerService playerService = PlayerService();

    return Container(
      color: Colors.white.withOpacity(0.4),
      child: Theme(
        data: theme.copyWith(checkboxTheme: newCheckBoxTheme),
        child: ListTile(
          onTap: () => widget.onChanged(false),
          onLongPress: () => {
            showDialog(
              context: context,
              builder: (context) {
                return FutureBuilder(
                  future: cardService.getCardIdsForPopup(widget.card),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return CardPopup(cardIds: snapshot.data!);
                    } else {
                      return const Text('Karte konnte nicht geladen werden');
                    }
                  },
                );
              },
            ),
          },
          title: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // https://stackoverflow.com/questions/57699497/how-to-create-a-background-with-stripes-in-flutter
                  cardColors != null
                      ? Container(
                          width: 68,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops:
                                  cardService.getStopsByColors(cardColors, 1),
                              colors: cardColors,
                              tileMode: TileMode.repeated,
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
              Row(
                children: <Widget>[
                  (widget.card.cardCost.coin != "" ||
                          widget.card.cardCost.debt != "")
                      ? CostComponent(
                          width: 40,
                          type:
                              widget.card.cardCost.coin != "" ? 'coin' : 'debt',
                          value: widget.card.cardCost.coin != ""
                              ? widget.card.cardCost.coin
                              : widget.card.cardCost.debt)
                      : Container(),
                  (widget.card.cardCost.coin != "" ||
                          widget.card.cardCost.debt != "")
                      ? const SizedBox(width: 2)
                      : Container(),
                  widget.card.cardCost.potion != ''
                      ? const CostComponent(width: 26, type: 'potion')
                      : const SizedBox(width: 26),
                  (widget.card.cardCost.coin != "" ||
                          widget.card.cardCost.debt != "")
                      ? Container()
                      : const SizedBox(width: 40),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.card.name,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      Text(
                        cardTypeString,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ],
                  ),
                  const Spacer(),
                  widget.hasCheckbox
                      ? RoundCheckbox(
                          onChanged: widget.onChanged,
                          value: widget.value,
                        )
                      : ExpansionIcon(icon: widget.card.id.split('-')[0])
                ],
              ),
              widget.card.count.isNotEmpty
                  ? Row(
                      children: [
                        const SizedBox(width: 36),
                        Container(
                          width: 40,
                          height: 18,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.white,
                          ),
                          child: ValueListenableBuilder(
                            valueListenable: playerService.notifier,
                            builder: (BuildContext context, bool val,
                                Widget? child) {
                              return Text(
                                widget.card.count[playerService.players - 1],
                                textAlign: TextAlign.center,
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : Container()
            ],
          ),
        ),
        // subtitle: const Text('This is tile number 2'),
      ),
    );
  }
}
