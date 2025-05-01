import '../../../../generated/l10n.dart';

enum PaymentType {
  income(1),
  outcome(2),
  unknown(-1);

  final int value;

  const PaymentType(this.value);

  static PaymentType fromValue(int? value) {
    switch (value) {
      case 1:
        return PaymentType.income;
      case 2:
        return PaymentType.outcome;
      default:
        return PaymentType.unknown;
    }
  }

  String get displayName {
    switch (this) {
      case PaymentType.income:
        return S.current.income;
      case PaymentType.outcome:
        return S.current.outcome;
      case PaymentType.unknown:
        return S.current.unknown;
    }
  }
}
