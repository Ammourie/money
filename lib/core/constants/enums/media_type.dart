enum MediaType {
  None(-1),
  Image(1),
  Video(2);

  const MediaType(this.value);
  final int value;
  static MediaType mapToType(int? i) {
    switch (i) {
      case 1:
        return MediaType.Image;
      case 2:
        return MediaType.Video;

      default:
        return MediaType.None;
    }
  }
}
