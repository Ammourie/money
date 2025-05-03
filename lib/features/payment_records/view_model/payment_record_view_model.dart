import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:slim_starter_application/core/common/view_model/base_view_model.dart';
import 'package:slim_starter_application/core/ui/error_ui/error_viewer/error_viewer.dart';
import 'package:slim_starter_application/core/ui/snackbars/show_snackbar.dart';
import 'package:slim_starter_application/core/ui/widgets/success_dialog.dart';
import 'package:slim_starter_application/features/home/view/app_main_view.dart';

import '../../../core/common/app_config.dart';
import '../../../core/constants/enums/success_dialog_type.dart';
import '../../../services/firebase_service.dart';
import '../model/enums/payment_type.dart';
import '../model/response/customer_model.dart';
import '../model/response/payment_record_model.dart';
import '../view/payment_record_view.dart';

class PaymentRecordViewModel extends BaseViewModel<PaymentRecordViewParam> {
  final PaymentRecordViewParam param;
  final PaymentFirebaseDataSource _firebaseDataSource;

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

  PaymentRecordViewModel(this.param)
      : _firebaseDataSource = PaymentFirebaseDataSource(),
        super(param) {
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

  Future<void> fetchCustomers() async {
    final result = await _firebaseDataSource.getCustomers();

    result.pick(
      onData: (customers) {
        _customers = customers;
        if (_customers.isNotEmpty) {
          _selectedCustomer = _customers[0];
        } else {
          _selectedCustomer = null;
        }
        notifyListeners();
      },
      onError: (error) {
        ErrorViewer.showError(
          context: AppConfig().appContext!,
          error: error,
          callback: () => fetchCustomers(),
        );
      },
    );
  }

  Future<void> addCustomer(CustomerModel customer) async {
    _isAddingCustomer = true;
    notifyListeners();

    final result = await _firebaseDataSource.addCustomer(customer);

    result.pick(
      onData: (customerWithId) {
        _customers.add(customerWithId);
        _selectedCustomer = customerWithId;
        notifyListeners();
        showSnackbar("Customer added successfully");
      },
      onError: (error) {
        ErrorViewer.showError(
          context: AppConfig().appContext!,
          error: error,
          callback: () => addCustomer(customer),
        );
      },
    );

    _isAddingCustomer = false;
    notifyListeners();
  }

  Future<void> submitPaymentRecord() async {
    log('Starting payment record submission', name: 'submitPaymentRecord');

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

        final result =
            await _firebaseDataSource.submitPaymentRecord(paymentRecord);

        result.pick(
          onData: (updatedRecord) {
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
            log('Payment record submitted successfully',
                name: 'submitPaymentRecord');
          },
          onError: (error) {
            ErrorViewer.showError(
              context: AppConfig().appContext!,
              error: error,
              callback: () => submitPaymentRecord(),
            );
          },
        );
      } finally {
        _isSubmitting = false;
        notifyListeners();
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
