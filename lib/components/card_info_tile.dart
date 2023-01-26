import 'package:dominion_comanion/components/coin_component.dart';
import 'package:dominion_comanion/components/round_checkbox.dart';
import 'package:dominion_comanion/model/card/card_model.dart';
import 'package:dominion_comanion/services/card_service.dart';
import 'package:flutter/material.dart';

class CardInfoTile extends StatefulWidget {
  const CardInfoTile({
    super.key,
    required this.card,
    required this.onChanged,
    required this.value,
  });

  final void Function(bool? value) onChanged;
  final CardModel card;
  final bool value;

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

    return Container(
      /* decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          //I assumed you want to occupy the entire space of the card
          image: AssetImage(
            "assets/cards/types/small/${cardService.getFilenameByCardTypes(widget.card.cardTypes)}.jpg",
          ),
        ),
      ),*/
      color: Colors.white.withOpacity(0.4),
      child: Theme(
        data: theme.copyWith(checkboxTheme: newCheckBoxTheme),
        child: ListTile(
          onTap: () => widget.onChanged(false),
          title: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 72,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          "assets/cards/types/small/${cardService.getFilenameByCardTypes(widget.card.cardTypes)}.jpg",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  CostComponent(
                      width: 40,
                      type: widget.card.cardCost.coin != "" ? 'coin' : 'debt',
                      value: widget.card.cardCost.coin != ""
                          ? widget.card.cardCost.coin
                          : widget.card.cardCost.debt),
                  const SizedBox(width: 2),
                  widget.card.cardCost.potion != ''
                      ? const CostComponent(width: 26, type: 'potion')
                      : const SizedBox(width: 26),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.card.name,
                        style: const TextStyle(
                            fontFamily: 'TrajanPro',
                            fontSize: 18,
                            color: Colors.black),
                      ),
                      Text(
                        cardService.getCardTypesString(widget.card.cardTypes),
                        style: const TextStyle(
                            fontFamily: 'TrajanPro',
                            fontSize: 14,
                            color: Colors.black),
                      ),
                    ],
                  ),
                  const Spacer(),
                  RoundCheckbox(
                    onChanged: widget.onChanged,
                    value: widget.value,
                  )
                ],
              ),
            ],
          ),
        ),
        // subtitle: const Text('This is tile number 2'),
      ),
    );
  }
}
