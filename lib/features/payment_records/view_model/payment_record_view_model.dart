import 'package:slim_starter_application/core/common/view_model/base_view_model.dart';
import '../model/response/payment_record_model.dart';
import '../model/response/customer_model.dart';
import 'package:intl/intl.dart';

import '../view/payment_record_view.dart';

class PaymentRecordViewModel extends BaseViewModel<PaymentRecordViewParam> {
  final PaymentRecordViewParam param;
  final List<CustomerModel> _customers = [
    CustomerModel(id: "1", name: "John Doe", phone: "123-456-7890"),
    CustomerModel(id: "2", name: "Jane Smith", phone: "987-654-3210"),
    CustomerModel(id: "3", name: "Bob Johnson", phone: "555-123-4567"),
  ];

  CustomerModel? _selectedCustomer;
  String _serviceName = '';
  double _serviceCost = 0.0;
  DateTime _serviceDate = DateTime.now();
  String _notes = '';

  PaymentRecordViewModel(this.param) : super(param) {
    _init();
  }

  void _init() {
    // Initialize data if needed
    if (_customers.isNotEmpty) {
      _selectedCustomer = _customers[0];
    }
  }

  // Getters
  List<CustomerModel> get customers => _customers;
  CustomerModel? get selectedCustomer => _selectedCustomer;
  String get serviceName => _serviceName;
  double get serviceCost => _serviceCost;
  DateTime get serviceDate => _serviceDate;
  String get notes => _notes;

  // Setters
  void setSelectedCustomer(CustomerModel customer) {
    _selectedCustomer = customer;
    notifyListeners();
  }

  void setServiceName(String name) {
    _serviceName = name;
    notifyListeners();
  }

  void setServiceCost(double cost) {
    _serviceCost = cost;
    notifyListeners();
  }

  void setServiceDate(DateTime date) {
    _serviceDate = date;
    notifyListeners();
  }

  void setNotes(String notes) {
    _notes = notes;
    notifyListeners();
  }

  void addCustomer(CustomerModel customer) {
    _customers.add(customer);
    notifyListeners();
  }

  void submitPaymentRecord() {
    if (_selectedCustomer == null) {
      print("Error: No customer selected");
      return;
    }

    final paymentRecord = PaymentRecordModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      customerId: _selectedCustomer!.id,
      customerName: _selectedCustomer!.name,
      serviceName: _serviceName,
      serviceCost: _serviceCost,
      serviceDate: _serviceDate,
      notes: _notes,
      createdAt: DateTime.now(),
    );

    // For now, just print the data
    print("Payment Record Submitted:");
    print("Customer: ${paymentRecord.customerName}");
    print("Service: ${paymentRecord.serviceName}");
    print("Cost: \$${paymentRecord.serviceCost}");
    print(
        "Date: ${DateFormat('yyyy-MM-dd').format(paymentRecord.serviceDate)}");
    print("Notes: ${paymentRecord.notes}");
  }

  void closeModel() {
    // Clean up resources
  }
}
