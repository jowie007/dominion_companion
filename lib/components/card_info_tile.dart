import 'package:dominion_comanion/components/coin_component.dart';
import 'package:dominion_comanion/components/round_checkbox.dart';
import 'package:dominion_comanion/model/card/card_model.dart';
import 'package:flutter/material.dart';

class CardInfoTile extends StatelessWidget {
  const CardInfoTile({
    super.key,
    required this.card,
    required this.onChanged,
  });

  final void Function(bool? value) onChanged;
  final CardModel card;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final newCheckBoxTheme = theme.checkboxTheme.copyWith(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
    );

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          //I assumed you want to occupy the entire space of the card
          image: AssetImage(
            "assets/cards/types/small/${card.cardType.getFileName()}.png",
          ),
        ),
      ),
      child: Theme(
        data: theme.copyWith(checkboxTheme: newCheckBoxTheme),
        child: ListTile(
          onTap: () => onChanged(false),
          title: Row(
            children: <Widget>[
              CostComponent(
                  width: 40,
                  type: card.cardCost.coin != null ? 'coin' : 'debt',
                  value: card.cardCost.coin ?? card.cardCost.debt),
              const SizedBox(width: 2),
              card.cardCost.potion != null
                  ? const CostComponent(width: 26, type: 'potion')
                  : const SizedBox(width: 26),
              const SizedBox(width: 10),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.name,
                      style: const TextStyle(
                        fontFamily: 'TrajanPro', fontSize: 18, color: Colors.black),
                    ),
                    Text(
                      card.cardType.getFileName(),
                      style: const TextStyle(
                        fontFamily: 'TrajanPro', fontSize: 14, color: Colors.black),
                    ),
                  ]),
              const Spacer(),
              RoundCheckbox(
                onChanged: onChanged,
                value: false,
              )
            ],
          ),
          // subtitle: const Text('This is tile number 2'),
        ),
      ),
    );
  }
}
