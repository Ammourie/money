enum TicketType {
  None(-1),
  Question(1),
  Complaint(2),
  Suggestion(3);

  const TicketType(this.value);
  final int value;
  static TicketType mapToType(int? i) {
    switch (i) {
      case 1:
        return TicketType.Question;
      case 2:
        return TicketType.Complaint;
      case 3:
        return TicketType.Suggestion;
      default:
        return TicketType.None;
    }
  }
}
