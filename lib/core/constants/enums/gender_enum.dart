enum GenderEnum {
  None(-1),
  Male(1),
  Female(2);

  const GenderEnum(this.value);
  final int value;
  static GenderEnum mapToType(int? i) {
    switch (i) {
      case 1:
        return GenderEnum.Male;
      case 2:
        return GenderEnum.Female;

      default:
        return GenderEnum.None;
    }
  }
}
