import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:slim_starter_application/core/common/view_model/base_view_model.dart';
import 'package:slim_starter_application/core/ui/snackbars/show_snackbar.dart';
import 'package:slim_starter_application/core/ui/widgets/success_dialog.dart';
import 'package:slim_starter_application/features/home/view/app_main_view.dart';

import '../../../core/common/app_config.dart';
import '../../../core/constants/enums/success_dialog_type.dart';
import '../model/enums/payment_type.dart';
import '../model/response/customer_model.dart';
import '../model/response/payment_record_model.dart';
import '../view/payment_record_view.dart';

class PaymentRecordViewModel extends BaseViewModel<PaymentRecordViewParam> {
  final PaymentRecordViewParam param;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<CustomerModel> _customers = [];
  bool _isLoadingCustomers = false;
  bool _isSubmitting = false;
  bool _isAddingCustomer = false;

  CustomerModel? _selectedCustomer;
  DateTime _serviceDate = DateTime.now();
  PaymentType _paymentType = PaymentType.income;
  final formkey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController serviceNameController = TextEditingController();
  final TextEditingController serviceCostController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController customerPhoneController = TextEditingController();

  PaymentRecordViewModel(this.param) : super(param) {
    _init();
  }

  void _init() async {
    _isLoadingCustomers = true;
    notifyListeners();
    await fetchCustomers();
    _isLoadingCustomers = false;
    notifyListeners();
  }

  // Getters
  List<CustomerModel> get customers => _customers;
  CustomerModel? get selectedCustomer => _selectedCustomer;
  String get serviceName => serviceNameController.text;
  double get serviceCost => double.tryParse(serviceCostController.text) ?? 0.0;
  DateTime get serviceDate => _serviceDate;
  String get notes => notesController.text;
  bool get isLoadingCustomers => _isLoadingCustomers;
  bool get isSubmitting => _isSubmitting;
  bool get isAddingCustomer => _isAddingCustomer;
  PaymentType get paymentType => _paymentType;

  // Setters
  void setSelectedCustomer(CustomerModel customer) {
    _selectedCustomer = customer;
    notifyListeners();
  }

  void setServiceDate(DateTime date) {
    _serviceDate = date;
    notifyListeners();
  }

  void setPaymentType(PaymentType type) {
    _paymentType = type;
    notifyListeners();
  }

  // Clear form fields
  void clearForm() {
    if (_customers.isNotEmpty) {
      _selectedCustomer = _customers[0];
    } else {
      _selectedCustomer = null;
    }
    serviceNameController.clear();
    serviceCostController.clear();
    _serviceDate = DateTime.now();
    _paymentType = PaymentType.outcome;
    notesController.clear();
    formkey.currentState?.reset();
    notifyListeners();
  }

  // Firestore Operations
  String get _userId => _auth.currentUser?.uid ?? '';

  Future<void> fetchCustomers() async {
    if (_userId.isEmpty) {
      showSnackbar("You must be logged in to view customers");
      return;
    }

    try {
      final customersSnapshot = await _firestore
          .collection('pro_users')
          .doc(_userId)
          .collection('customers')
          .get();

      _customers = customersSnapshot.docs
          .map((doc) => CustomerModel.fromMap(doc.data()))
          .toList();

      // Set initial selected customer if list is not empty
      if (_customers.isNotEmpty) {
        _selectedCustomer = _customers[0];
      } else {
        _selectedCustomer = null;
      }

      notifyListeners();
    } catch (e) {
      print("Error fetching customers: $e");
      showSnackbar("Error loading customers: $e");
    }
  }

  Future<void> addCustomer(CustomerModel customer) async {
    if (_userId.isEmpty) {
      showSnackbar("You must be logged in to add a customer");
      return;
    }

    _isAddingCustomer = true;
    notifyListeners();

    try {
      // Generate a new document ID
      final docRef = _firestore
          .collection('pro_users')
          .doc(_userId)
          .collection('customers')
          .doc();

      // Update customer with the generated ID
      final customerWithId = CustomerModel(
        id: docRef.id,
        name: customer.name,
        phone: customer.phone,
      );

      // Save to Firestore
      await docRef.set(customerWithId.toMap());

      // Add to local list
      _customers.add(customerWithId);
      _selectedCustomer = customerWithId;

      notifyListeners();
      showSnackbar("Customer added successfully");
    } catch (e) {
      print("Error adding customer: $e");
      showSnackbar("Error adding customer: $e");
    } finally {
      _isAddingCustomer = false;
      notifyListeners();
    }
  }

  Future<void> submitPaymentRecord() async {
    log('Starting payment record submission', name: 'submitPaymentRecord');
    if (_userId.isEmpty) {
      log('Error: User not logged in', name: 'submitPaymentRecord');
      showSnackbar("You must be logged in to submit a payment record");
      return;
    }

    if (_selectedCustomer == null) {
      log('Error: No customer selected', name: 'submitPaymentRecord');
      showSnackbar("Error: No customer selected");
      return;
    }

    if (formkey.currentState!.validate()) {
      log('Form validated, proceeding with submission',
          name: 'submitPaymentRecord');
      _isSubmitting = true;
      notifyListeners();

      try {
        final paymentRecord = PaymentRecordModel(
          id: '', // Will be set by Firestore
          customer: _selectedCustomer,
          serviceName: serviceName,
          serviceCost: serviceCost,
          serviceDate: _serviceDate,
          notes: notes,
          createdAt: DateTime.now(),
          paymentType: _paymentType,
        );

        log('Created payment record model', name: 'submitPaymentRecord');

        // Save to Firestore
        log('Saving to Firestore', name: 'submitPaymentRecord');
        final docRef = await _firestore
            .collection('pro_users')
            .doc(_userId)
            .collection('payment_records')
            .add(paymentRecord.toMap());

        // Update the ID with Firestore's generated ID
        log('Updating record with Firestore ID: ${docRef.id}',
            name: 'submitPaymentRecord');
        await docRef.update({'id': docRef.id});
        log('Navigating back', name: 'submitPaymentRecord');
        showSuccessDialog(
          title: "Payment Record Submitted",
          content: "Payment record submitted successfully",
          buttonText: "OK",
          type: SuccessDialogType.type2,
          showConfetti: true,
          onButtonPressed: () {
            Navigator.popUntil(
              AppConfig().appContext!,
              ModalRoute.withName(AppMainView.routeName),
            );
          },
        );
        // Nav.pop();

        log('Payment record submitted successfully',
            name: 'submitPaymentRecord');
      } catch (e) {
        log('Error submitting payment record: $e', name: 'submitPaymentRecord');
        showSnackbar("Error submitting payment record: $e", isError: true);
      } finally {
        _isSubmitting = false;

        notifyListeners();
        // log('Submission process completed', name: 'submitPaymentRecord');
      }
    } else {
      log('Form validation failed', name: 'submitPaymentRecord');
    }
  }

  @override
  void closeModel() {
    serviceNameController.dispose();
    serviceCostController.dispose();
    notesController.dispose();
    customerNameController.dispose();
    customerPhoneController.dispose();
    this.dispose();
  }
}
