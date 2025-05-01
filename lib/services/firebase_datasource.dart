// // lib/core/datasources/firebase/payment_firebase_data_source.dart
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../../../features/payment_records/model/response/customer_model.dart';
// import '../../../features/payment_records/model/response/payment_record_model.dart';
// import '../core/errors/app_errors.dart';
// import '../core/results/result.dart';

// abstract class IPaymentFirebaseDataSource {
//   Future<Result<AppErrors, List<CustomerModel>>> getCustomers();
//   Future<Result<AppErrors, CustomerModel>> addCustomer(CustomerModel customer);
//   Future<Result<AppErrors, PaymentRecordModel>> submitPaymentRecord(
//       PaymentRecordModel paymentRecord);
// }

// class PaymentFirebaseDataSource implements IPaymentFirebaseDataSource {
//   final FirebaseFirestore _firestore;
//   final FirebaseAuth _auth;

//   PaymentFirebaseDataSource({
//     FirebaseFirestore? firestore,
//     FirebaseAuth? auth,
//   })  : _firestore = firestore ?? FirebaseFirestore.instance,
//         _auth = auth ?? FirebaseAuth.instance;

//   String get _userId => _auth.currentUser?.uid ?? '';

//   @override
//   Future<Result<AppErrors, List<CustomerModel>>> getCustomers() async {
//     if (_userId.isEmpty) {
//       return Result.error(
//         UnauthorizedError(),
//       );
//     }

//     try {
//       final customersSnapshot = await _firestore
//           .collection('users')
//           .doc(_userId)
//           .collection('customers')
//           .get();

//       final customers = customersSnapshot.docs
//           .map((doc) => CustomerModel.fromMap(doc.data()))
//           .toList();

//       return Result.data(customers);
//     } catch (e) {
//       print("Error fetching customers: $e");
//       return Result.error(
//         CustomError(message: "Error loading customers: $e"),
//       );
//     }
//   }

//   @override
//   Future<Result<AppErrors, CustomerModel>> addCustomer(
//       CustomerModel customer) async {
//     if (_userId.isEmpty) {
//       return Result.error(
//         UnauthorizedError(),
//       );
//     }

//     try {
//       // Generate a new document ID
//       final docRef = _firestore
//           .collection('users')
//           .doc(_userId)
//           .collection('customers')
//           .doc();

//       // Update customer with the generated ID
//       final customerWithId = CustomerModel(
//         id: docRef.id,
//         name: customer.name,
//         phone: customer.phone,
//       );

//       // Save to Firestore
//       await docRef.set(customerWithId.toMap());

//       return Result.data(customerWithId);
//     } catch (e) {
//       print("Error adding customer: $e");
//       return Result.error(
//         CustomError(message: "Error adding customer: $e"),
//       );
//     }
//   }

//   @override
//   Future<Result<AppErrors, PaymentRecordModel>> submitPaymentRecord(
//       PaymentRecordModel paymentRecord) async {
//     if (_userId.isEmpty) {
//       return Result.error(
//         UnauthorizedError(),
//       );
//     }

//     try {
//       // Save to Firestore
//       final docRef = await _firestore
//           .collection('users')
//           .doc(_userId)
//           .collection('paymentRecords')
//           .add(paymentRecord.toMap());

//       // Update the ID with Firestore's generated ID
//       final updatedRecord = PaymentRecordModel(
//         id: docRef.id,
//         customer: paymentRecord.customer,
//         serviceName: paymentRecord.serviceName,
//         serviceCost: paymentRecord.serviceCost,
//         serviceDate: paymentRecord.serviceDate,
//         notes: paymentRecord.notes,
//         createdAt: paymentRecord.createdAt,
//       );

//       await docRef.update({'id': docRef.id});

//       return Result.data(updatedRecord);
//     } catch (e) {
//       print("Error submitting payment record: $e");
//       return Result.error(
//         CustomError(message: "Error submitting payment record: $e"),
//       );
//     }
//   }
// }
