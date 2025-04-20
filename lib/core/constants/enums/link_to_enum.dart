enum LinkToEnum {
  None(-1);

  final int mapToInt;
  const LinkToEnum(this.mapToInt);

  static LinkToEnum mapToType(int? v) {
    switch (v) {
      default:
        return LinkToEnum.None;
    }
  }
}
