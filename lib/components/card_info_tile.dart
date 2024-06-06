import 'package:dominion_companion/components/card_popup.dart';
import 'package:dominion_companion/components/coin_component.dart';
import 'package:dominion_companion/components/custom_alert_dialog.dart';
import 'package:dominion_companion/components/round_checkbox.dart';
import 'package:dominion_companion/components/expansion_icon.dart';
import 'package:dominion_companion/components/select_another_card_dialog.dart';
import 'package:dominion_companion/model/card/card_model.dart';
import 'package:dominion_companion/services/card_service.dart';
import 'package:dominion_companion/services/player_service.dart';
import 'package:flutter/material.dart';

class CardInfoTile extends StatefulWidget {
  const CardInfoTile({
    super.key,
    required this.card,
    required this.onChanged,
    required this.value,
    this.dismissable = false,
    this.onSwapRandom,
    this.onSwapManual,
    this.hasCheckbox = true,
    this.showCardCount = false,
  });

  final void Function(bool? value) onChanged;
  final void Function()? onSwapRandom;
  final void Function(String newCardId)? onSwapManual;
  final CardModel card;
  final bool value;
  final bool dismissable;
  final bool hasCheckbox;
  final bool showCardCount;

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

    return Dismissible(
      key: UniqueKey(),
      direction: widget.dismissable && widget.onSwapRandom != null
          ? DismissDirection.horizontal
          : DismissDirection.none,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomAlertDialog(
                title: 'Karte zufällig ersetzen',
                message:
                'Möchtest du die Karte "${widget.card
                    .name}" durch eine zufällige aus deiner Auswahl ersetzen?',
                onConfirm: () {
                  widget.onSwapRandom!();
                },
              );
            },
          );
        } else if (direction == DismissDirection.startToEnd) {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return SelectAnotherCardDialog(
                  onSaved:
                      (String newCardId) => widget.onSwapManual!(newCardId),
                  currentCard: widget.card);
            },
          );
        }
        return false;
      },
      background: Container(
        color: Colors.brown, // Change this to your desired color
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 26),
        child: const Icon(Icons.swap_vert_circle_outlined, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.brown,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 26),
        child: const Icon(Icons.swap_vert, color: Colors.white),
      ),
      child: Container(
        color: Colors.white.withOpacity(0.4),
        child: Theme(
          data: theme.copyWith(checkboxTheme: newCheckBoxTheme),
          child: ListTile(
            onTap: () => widget.onChanged(false),
            onLongPress: () =>
            {
              showDialog(
                context: context,
                builder: (context) {
                  return FutureBuilder(
                    future: cardService.getCardIdsForPopup(widget.card),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasData && snapshot.data != null) {
                        return CardPopup(
                            cardIds: snapshot.data!,
                            expansionId: snapshot.data![0].split("-")[0]);
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
                  children: <Widget>[
                    SizedBox(
                      width: 74,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // https://stackoverflow.com/questions/57699497/how-to-create-a-background-with-stripes-in-flutter
                              cardColors != null
                                  ? Container(
                                width: 68,
                                height: 48,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(100),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: cardService.getStopsByColors(
                                        cardColors, 1),
                                    colors: cardColors,
                                    tileMode: TileMode.repeated,
                                  ),
                                ),
                              )
                                  : Container(),
                            ],
                          ),
                          widget.card.cardCost.debt != ''
                              ? widget.card.cardCost.coin != ''
                              ? Positioned(
                            top: 3,
                            left: 24,
                            child: CostComponent(
                                width: 40,
                                type: 'debt',
                                value: widget.card.cardCost.debt),
                          )
                              : Positioned(
                            left: 2,
                            top: 3,
                            child: CostComponent(
                                width: 40,
                                type: 'debt',
                                value: widget.card.cardCost.debt),
                          )
                              : Container(),
                          widget.card.cardCost.potion != ''
                              ? widget.card.cardCost.coin != ''
                              ? const Positioned(
                            left: 28,
                            top: 3,
                            child: CostComponent(
                                width: 26, type: 'potion'),
                          )
                              : const Positioned(
                            left: 8,
                            top: 3,
                            child: CostComponent(
                                width: 26, type: 'potion'),
                          )
                              : Container(),
                          widget.card.cardCost.coin != ''
                              ? Positioned(
                            top: 3,
                            left: 2,
                            child: CostComponent(
                                width: 40,
                                type: 'coin',
                                value: widget.card.cardCost.coin),
                          )
                              : const SizedBox(width: 26),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 8,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.card.name,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                          ),
                          Text(
                            cardTypeString,
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
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
                widget.card.count.isNotEmpty && widget.showCardCount
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
      ),
    );
  }
}
