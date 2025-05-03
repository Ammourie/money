import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slim_starter_application/core/common/type_validators.dart';
import 'package:slim_starter_application/core/models/base_model.dart';

import '../enums/payment_type.dart';
import 'customer_model.dart';

class PaymentRecordModel extends BaseModel {
  final String id;
  final CustomerModel? customer;
  final String serviceName;
  final double? serviceCost;
  final DateTime? serviceDate;
  final String notes;
  final DateTime? createdAt;
  final PaymentType paymentType;

  PaymentRecordModel({
    required this.id,
    required this.customer,
    required this.serviceName,
    required this.serviceCost,
    required this.serviceDate,
    required this.notes,
    required this.createdAt,
    required this.paymentType,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer': customer?.toMap(),
      'serviceName': serviceName,
      'serviceCost': serviceCost,
      'serviceDate': serviceDate?.toIso8601String(),
      'notes': notes,
      'createdAt': createdAt?.toIso8601String(),
      'paymentType': paymentType.value,
    };
  }

  factory PaymentRecordModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return PaymentRecordModel(
      id: stringV(doc.id),
      customer: data['customer'] != null
          ? CustomerModel.fromMap(data['customer'])
          : null,
      serviceName: stringV(data['serviceName']),
      serviceCost: numV(data['serviceCost']),
      serviceDate: dateTimeV(data['serviceDate']),
      notes: stringV(data['notes']),
      createdAt: dateTimeV(data['createdAt']),
      paymentType: PaymentType.fromValue(numV(data['paymentType'])),
    );
  }
}
