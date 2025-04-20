enum BannerLocationEnum {
  None(-1);

  final int mapToInt;
  const BannerLocationEnum(this.mapToInt);

  static BannerLocationEnum mapToType(int? v) {
    switch (v) {
      default:
        return BannerLocationEnum.None;
    }
  }
}
