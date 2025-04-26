import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../generated/l10n.dart';
import '../view_model/payment_record_view_model.dart';
import '../model/response/customer_model.dart';

class PaymentRecordViewContent extends StatelessWidget {
  const PaymentRecordViewContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PaymentRecordViewModel>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        title: Text(
          S.current.paymentRecord,
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // Show information about payments
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Payment information')),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(top: 20, bottom: 100),
            children: [
              // Amount Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          theme.primaryColor,
                          theme.primaryColor.withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Amount',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              '\$${viewModel.serviceCost.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Payment',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Customer Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Customer',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: theme.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildCustomerDropdown(context, viewModel),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: () =>
                              _showAddCustomerDialog(context, viewModel),
                          icon:
                              Icon(Icons.person_add, color: theme.primaryColor),
                          label: Text('Add New Customer'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                            side: BorderSide(color: theme.primaryColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Service Details Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Service Details',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: theme.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildServiceNameField(context, viewModel),
                        const SizedBox(height: 16),
                        _buildServiceCostField(context, viewModel),
                        const SizedBox(height: 16),
                        _buildServiceDateField(context, viewModel),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Additional Info Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Additional Information',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: theme.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildNotesField(context, viewModel),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),

          // Bottom action button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: ElevatedButton(
                  onPressed: viewModel.submitPaymentRecord,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle),
                      const SizedBox(width: 8),
                      Text(
                        'Submit Payment Record',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerDropdown(
      BuildContext context, PaymentRecordViewModel viewModel) {
    return DropdownButtonFormField<CustomerModel>(
      decoration: InputDecoration(
        labelText: 'Select Customer',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: Theme.of(context).primaryColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        prefixIcon: Icon(Icons.person,
            color: Theme.of(context).primaryColor.withOpacity(0.7)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      value: viewModel.selectedCustomer,
      selectedItemBuilder: (BuildContext context) {
        return viewModel.customers.map<Widget>((CustomerModel customer) {
          return Text(
            customer.name,
            overflow: TextOverflow.ellipsis,
          );
        }).toList();
      },
      items: viewModel.customers.map((customer) {
        return DropdownMenuItem<CustomerModel>(
          value: customer,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundColor:
                    Theme.of(context).primaryColor.withOpacity(0.1),
                child: Text(
                  customer.name.isNotEmpty ? customer.name.substring(0, 1) : '',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      customer.name,
                      style: TextStyle(fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (customer.phone.isNotEmpty)
                      Text(
                        customer.phone,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (customer) {
        if (customer != null) {
          viewModel.setSelectedCustomer(customer);
        }
      },
      icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).primaryColor),
      isExpanded: true,
      dropdownColor: Colors.white,
    );
  }

  Widget _buildServiceNameField(
      BuildContext context, PaymentRecordViewModel viewModel) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Service Name',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: Theme.of(context).primaryColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        prefixIcon: Icon(Icons.home_repair_service,
            color: Theme.of(context).primaryColor.withOpacity(0.7)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      onChanged: viewModel.setServiceName,
    );
  }

  Widget _buildServiceCostField(
      BuildContext context, PaymentRecordViewModel viewModel) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Service Cost',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: Theme.of(context).primaryColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        prefixIcon: Icon(Icons.attach_money,
            color: Theme.of(context).primaryColor.withOpacity(0.7)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (value) {
        if (value.isNotEmpty) {
          viewModel.setServiceCost(double.tryParse(value) ?? 0.0);
        }
      },
    );
  }

  Widget _buildServiceDateField(
      BuildContext context, PaymentRecordViewModel viewModel) {
    return InkWell(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: viewModel.serviceDate,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: Theme.of(context).primaryColor,
                ),
                dialogBackgroundColor: Colors.white,
              ),
              child: child!,
            );
          },
        );
        if (selectedDate != null) {
          viewModel.setServiceDate(selectedDate);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Service Date',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          prefixIcon: Icon(Icons.calendar_today,
              color: Theme.of(context).primaryColor.withOpacity(0.7)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('MMM dd, yyyy').format(viewModel.serviceDate),
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesField(
      BuildContext context, PaymentRecordViewModel viewModel) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Notes',
        alignLabelWithHint: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: Theme.of(context).primaryColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        prefixIcon: Icon(Icons.note,
            color: Theme.of(context).primaryColor.withOpacity(0.7)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      maxLines: 4,
      onChanged: viewModel.setNotes,
    );
  }

  void _showAddCustomerDialog(
      BuildContext context, PaymentRecordViewModel viewModel) {
    String name = '';
    String phone = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.person_add, color: Theme.of(context).primaryColor),
              const SizedBox(width: 12),
              Text('Add New Customer'),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Customer Name',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                  ),
                  onChanged: (value) {
                    name = value;
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                  ),
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    phone = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (name.isNotEmpty) {
                  // Create a new customer
                  final newCustomer = CustomerModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: name,
                    phone: phone,
                  );
                  viewModel.addCustomer(newCustomer);
                  viewModel.setSelectedCustomer(newCustomer);
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Theme.of(context).primaryColor,
              ),
              child: const Text('Add Customer'),
            ),
          ],
        );
      },
    );
  }
}
