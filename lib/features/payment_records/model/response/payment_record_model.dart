import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slim_starter_application/core/common/type_validators.dart';
import 'package:slim_starter_application/core/models/base_model.dart';

class PaymentRecordModel extends BaseModel {
  final String id;
  final String customerId;
  final String customerName;
  final String serviceName;
  final double? serviceCost;
  final DateTime serviceDate;
  final String notes;
  final DateTime createdAt;

  PaymentRecordModel({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.serviceName,
    required this.serviceCost,
    required this.serviceDate,
    required this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'serviceName': serviceName,
      'serviceCost': serviceCost,
      'serviceDate': Timestamp.fromDate(serviceDate),
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory PaymentRecordModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return PaymentRecordModel(
      id: stringV(doc.id),
      customerId: stringV(data['customerId']),
      customerName: stringV(data['customerName']),
      serviceName: stringV(data['serviceName']),
      serviceCost: numV(data['serviceCost']), 
      serviceDate: (data['serviceDate'] as Timestamp).toDate(),
      notes: stringV(data['notes']),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
