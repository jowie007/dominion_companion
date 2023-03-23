enum HandTypeEnum {
  moneyCards,
  otherCards,
  contents,
}

extension HandTypeEnumExtension on HandTypeEnum {
  String? get dbString {
    switch (this) {
      case HandTypeEnum.moneyCards:
        return 'hand_money_cards';
      case HandTypeEnum.otherCards:
        return 'hand_other_cards';
      case HandTypeEnum.contents:
        return 'hand_contents';
      default:
        return null;
    }
  }
}
