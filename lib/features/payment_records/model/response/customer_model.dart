import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slim_starter_application/core/common/type_validators.dart';
import 'package:slim_starter_application/core/models/base_model.dart';

class CustomerModel extends BaseModel {
  final String id;
  final String name;
  final String phone;

  CustomerModel({
    required this.id,
    required this.name,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
    };
  }

  factory CustomerModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return CustomerModel(
      id: stringV(doc.id),
      name: stringV(data['name']),
      phone: stringV(data['phone']),
    );
  }
  factory CustomerModel.fromMap(Map<String, dynamic> data) {
    return CustomerModel(
      id: stringV(data['id']),
      name: stringV(data['name']),
      phone: stringV(data['phone']),
    );
  }
}
