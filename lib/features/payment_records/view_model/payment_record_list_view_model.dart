import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/common/view_model/base_view_model.dart';
import '../../../di/service_locator.dart';
import '../../../services/firebase_service.dart';
import '../model/enums/payment_type.dart';
import '../model/response/customer_model.dart';
import '../model/response/payment_record_model.dart';
import '../view/payment_record_list_view.dart';

class PaymentRecordListViewModel
    extends BaseViewModel<PaymentRecordListViewParam> {
  // final PaymentRecordListViewParam param;
  final TextEditingController searchQueryController = TextEditingController();

  // States
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  List<PaymentRecordModel> _paymentRecords = [];
  List<CustomerModel> _customers = [];

  // Filter states
  DateTime? _startDate;
  DateTime? _endDate;
  String _searchQuery = '';
  PaymentType? _selectedPaymentType;
  CustomerModel? _selectedCustomer;
  bool _isFiltering = false;

  // Getters
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  List<PaymentRecordModel> get paymentRecords => _paymentRecords;
  List<CustomerModel> get customers => _customers;

  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  String get searchQuery => _searchQuery;
  PaymentType? get selectedPaymentType => _selectedPaymentType;
  CustomerModel? get selectedCustomer => _selectedCustomer;
  bool get isFiltering => _isFiltering;

  // Total calculations
  double get totalIncome => filteredPaymentRecords
      .where((record) => record.paymentType == PaymentType.income)
      .fold(0, (sum, record) => sum + (record.serviceCost ?? 0));

  double get totalExpense => filteredPaymentRecords
      .where((record) => record.paymentType == PaymentType.outcome)
      .fold(0, (sum, record) => sum + (record.serviceCost ?? 0));

  double get netAmount => totalIncome - totalExpense;

  List<PaymentRecordModel> get filteredPaymentRecords {
    return _paymentRecords.where((record) {
      // Apply search filter
      if (_searchQuery.isNotEmpty) {
        final searchLower = _searchQuery.toLowerCase();
        if (!record.serviceName.toLowerCase().contains(searchLower) &&
            !(record.customer?.name ?? "")
                .toLowerCase()
                .contains(searchLower) &&
            !record.notes.toLowerCase().contains(searchLower)) {
          return false;
        }
      }

      // Apply payment type filter
      if (_selectedPaymentType != null &&
          record.paymentType != _selectedPaymentType) {
        return false;
      }

      // Apply customer filter
      if (_selectedCustomer != null &&
          record.customer?.id != _selectedCustomer!.id) {
        return false;
      }

      // Apply date range filter
      if (_startDate != null) {
        final recordDate = DateTime(
          record.serviceDate?.year ?? DateTime.now().year,
          record.serviceDate?.month ?? DateTime.now().month,
          record.serviceDate?.day ?? DateTime.now().day,
        );
        final filterStartDate = DateTime(
          _startDate!.year,
          _startDate!.month,
          _startDate!.day,
        );

        if (recordDate.isBefore(filterStartDate)) {
          return false;
        }
      }

      if (_endDate != null) {
        final recordDate = DateTime(
          record.serviceDate?.year ?? DateTime.now().year,
          record.serviceDate?.month ?? DateTime.now().month,
          record.serviceDate?.day ?? DateTime.now().day,
        );
        final filterEndDate = DateTime(
          _endDate!.year,
          _endDate!.month,
          _endDate!.day,
        );

        if (recordDate.isAfter(filterEndDate)) {
          return false;
        }
      }

      // Include the record if it passed all filters
      return true;
    }).toList();
  }

  PaymentRecordListViewModel(super.param) {
    _init();
  }

  void _init() async {
    await loadData();
  }

  Future<void> loadData() async {
    _setLoading(true);
    try {
      // In real implementation, fetch data from API or local database
      await Future.delayed(
          const Duration(seconds: 1)); // Simulate network delay

      _customers = await _getCustomers();

      // Generate dummy payment records
      _paymentRecords = _generateDummyPaymentRecords();

      _setLoading(false);
    } catch (e) {
      _setError('Failed to load payment records: $e');
    }
  }

  void refreshData() async {
    await loadData();
  }

  Future<List<CustomerModel>> _getCustomers() async {
    final res = await getIt<IFirebaseService>().getCustomers();
    List<CustomerModel> customers = [];
    res.pick(
      onData: (data) => customers = data,
      onError: (error) => customers = [],
    );
    return customers;
  }

  List<PaymentRecordModel> _generateDummyPaymentRecords() {
    final random = Random();
    final now = DateTime.now();
    final records = <PaymentRecordModel>[];

    // Service names
    final serviceNames = [
      'Lawn Mowing',
      'House Cleaning',
      'Plumbing Repair',
      'Electrical Work',
      'Painting Service',
      'Furniture Assembly',
      'Window Cleaning',
      'Carpet Cleaning',
      'HVAC Maintenance',
      'Pest Control'
    ];

    // Generate 20 random payment records
    for (int i = 0; i < 20; i++) {
      final customer = _customers[random.nextInt(_customers.length)];
      final paymentType =
          random.nextBool() ? PaymentType.income : PaymentType.outcome;
      final daysAgo = random.nextInt(60); // Random date within last 60 days

      records.add(
        PaymentRecordModel(
          id: 'record_$i',
          customer: customer,
          serviceName: serviceNames[random.nextInt(serviceNames.length)],
          serviceCost: (random.nextInt(50000) / 100) +
              50, // Random amount between $50 and $550
          serviceDate: now.subtract(Duration(days: daysAgo)),
          paymentType: paymentType,
          notes: random.nextBool()
              ? 'Notes for service provided to ${customer.name}'
              : '',
          createdAt:
              now.subtract(Duration(days: daysAgo, hours: random.nextInt(24))),
        ),
      );
    }

    // Sort by date (newest first)
    records.sort((a, b) => b.serviceDate!.compareTo(a.serviceDate!));

    return records;
  }

  void deletePaymentRecord(String recordId) async {
    _setLoading(true);
    try {
      // In real implementation, delete from API or local database
      await Future.delayed(
          const Duration(milliseconds: 500)); // Simulate network delay

      // Remove from local list
      _paymentRecords.removeWhere((record) => record.id == recordId);
      notifyListeners();

      _setLoading(false);
    } catch (e) {
      _setError('Failed to delete payment record: $e');
    }
  }

  // Filter setters
  void setSearchQuery(String query) {
    _searchQuery = query;
    _isFiltering = _isAnyFilterActive();

    notifyListeners();
  }

  void setDateRange(DateTime? start, DateTime? end) {
    _startDate = start;
    _endDate = end;
    _isFiltering = _isAnyFilterActive();
    notifyListeners();
  }

  void setSelectedPaymentType(PaymentType? type) {
    _selectedPaymentType = type;
    _isFiltering = _isAnyFilterActive();
    notifyListeners();
  }

  void setSelectedCustomer(CustomerModel? customer) {
    _selectedCustomer = customer;
    _isFiltering = _isAnyFilterActive();
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _startDate = null;
    _endDate = null;
    _selectedPaymentType = null;
    _selectedCustomer = null;
    _isFiltering = false;
    searchQueryController.clear();
    notifyListeners();
  }

  bool _isAnyFilterActive() {
    return _searchQuery.isNotEmpty ||
        _startDate != null ||
        _endDate != null ||
        _selectedPaymentType != null ||
        _selectedCustomer != null;
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    if (loading) {
      _hasError = false;
      _errorMessage = '';
    }
    notifyListeners();
  }

  void _setError(String message) {
    _hasError = true;
    _errorMessage = message;
    _isLoading = false;
    notifyListeners();
  }

  void closeModel() {
    // Clean up resources if needed
  }
}
