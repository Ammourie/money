enum LinkToType {
  None(-1);

  const LinkToType(this.value);
  final int value;
  static LinkToType mapToType(int? i) {
    switch (i) {
      default:
        return LinkToType.None;
    }
  }
}
