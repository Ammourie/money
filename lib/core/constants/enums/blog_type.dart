enum BlogType {
  None(-1),
  General(0);

  const BlogType(this.value);
  final int value;
  static BlogType mapToType(int? i) {
    switch (i) {
      case 0:
        return BlogType.General;

      default:
        return BlogType.None;
    }
  }
}
