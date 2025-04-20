enum NotificationType {
  None(-1);

  final int mapToInt;
  const NotificationType(this.mapToInt);

  static NotificationType mapToType(int? v) {
    switch (v) {
      default:
        return NotificationType.None;
    }
  }
}
