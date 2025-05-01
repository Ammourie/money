import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      appBar: _buildAppBar(context, theme),
      body: Form(
        key: viewModel.formkey,
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.only(top: 20.h, bottom: 100.h),
              children: [
                _buildAmountCard(context, viewModel, theme),
                32.verticalSpace,
                _buildCustomerSection(context, viewModel, theme),
                32.verticalSpace,
                _buildServiceDetailsSection(context, viewModel, theme),
                32.verticalSpace,
                _buildAdditionalInfoSection(context, viewModel, theme),
                40.verticalSpace,
              ],
            ),
            _buildBottomActionButton(context, viewModel, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(ThemeData theme) {
    return Center(
      child: CircularProgressIndicator(
        color: theme.primaryColor,
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, ThemeData theme) {
    return AppBar(
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20.r),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () {
            // Show information about payments
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(S.current.paymentInformation)),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAmountCard(
      BuildContext context, PaymentRecordViewModel viewModel, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Container(
          padding: EdgeInsets.all(32.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
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
                S.current.totalAmount,
                style:
                    theme.textTheme.titleMedium?.copyWith(color: Colors.white),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  //TODO: dollar sign fix later
                  Text(
                    '\$${viewModel.serviceCost.toStringAsFixed(2)}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 32.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      S.current.payment,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Text _buildSectionName(String title, ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.titleSmall
          ?.copyWith(color: theme.primaryColor, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildCustomerSection(
      BuildContext context, PaymentRecordViewModel viewModel, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: _buildSectionName(S.current.customer, theme),
        ),
        SizedBox(height: 12.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                children: [
                  viewModel.isLoadingCustomers
                      ? SizedBox(
                          height: 60.h,
                          child: _buildLoadingIndicator(theme),
                        )
                      : _buildCustomerDropdown(context, viewModel),
                  32.verticalSpace,
                  OutlinedButton.icon(
                    onPressed: viewModel.isSubmitting
                        ? null
                        : () => _showAddCustomerDialog(context, viewModel),
                    icon: Icon(Icons.person_add, color: theme.primaryColor),
                    label: Text(S.current.addNewCustomer),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          vertical: 12.h, horizontal: 12.w),
                      side: BorderSide(color: theme.primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceDetailsSection(
      BuildContext context, PaymentRecordViewModel viewModel, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: _buildSectionName(S.current.serviceDetails, theme),
        ),
        SizedBox(height: 12.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                children: [
                  _buildServiceNameField(context, viewModel),
                  32.verticalSpace,
                  _buildServiceCostField(context, viewModel),
                  32.verticalSpace,
                  _buildServiceDateField(context, viewModel),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalInfoSection(
      BuildContext context, PaymentRecordViewModel viewModel, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: _buildSectionName(S.current.additionalInformation, theme),
        ),
        SizedBox(height: 12.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: _buildNotesField(context, viewModel),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActionButton(
      BuildContext context, PaymentRecordViewModel viewModel, ThemeData theme) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(16.r),
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
            onPressed:
                viewModel.isSubmitting ? null : viewModel.submitPaymentRecord,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              elevation: 3,
            ),
            child: viewModel.isSubmitting
                ? SizedBox(
                    height: 20.h,
                    width: 20.w,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.w,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle),
                      8.horizontalSpace,
                      Text(
                        S.current.submitPaymentRecord,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  InputDecoration _getInputDecoration(
      BuildContext context, String labelText, IconData? icon) {
    final textTheme = Theme.of(context).textTheme;

    return InputDecoration(
      labelText: labelText,
      labelStyle: textTheme.labelLarge?.copyWith(fontSize: 28.sp),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
      prefixIcon:
          Icon(icon, color: Theme.of(context).primaryColor.withOpacity(0.7)),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    );
  }

  Widget _buildCustomerDropdown(
    BuildContext context,
    PaymentRecordViewModel viewModel,
  ) {
    final textTheme = Theme.of(context).textTheme;

    // Handle empty customers list
    if (viewModel.customers.isEmpty) {
      return SizedBox(
        width: 1.sw,
        child: Column(
          children: [
            Text(
              S.current.noCustomersFound,
              style: textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            16.verticalSpace,
            Text(
              S.current.addNewCustomerBelow,
              style:
                  textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return DropdownButtonFormField<CustomerModel>(
      decoration:
          _getInputDecoration(context, S.current.selectCustomer, Icons.person),
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
              12.horizontalSpace,
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      customer.name,
                      style: textTheme.titleSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (customer.phone.isNotEmpty)
                      Text(
                        customer.phone,
                        style: textTheme.labelSmall?.copyWith(
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
      onChanged: viewModel.isSubmitting
          ? null
          : (customer) {
              if (customer != null) {
                viewModel.setSelectedCustomer(customer);
              }
            },
      icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).primaryColor),
      isExpanded: true,
      dropdownColor: Colors.white,
      validator: (value) {
        if (value == null) {
          return S.current.errorEmptyField;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget _buildServiceNameField(
      BuildContext context, PaymentRecordViewModel viewModel) {
    return TextFormField(
      controller: viewModel.serviceNameController,
      decoration: _getInputDecoration(
          context, S.current.serviceName, Icons.home_repair_service),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return S.current.errorEmptyField;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enabled: !viewModel.isSubmitting,
    );
  }

  Widget _buildServiceCostField(
      BuildContext context, PaymentRecordViewModel viewModel) {
    return TextFormField(
      controller: viewModel.serviceCostController,
      decoration: _getInputDecoration(
          context, S.current.serviceCost, Icons.attach_money),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return S.current.errorEmptyField;
        }
        if (double.tryParse(value) == null) {
          return S.current.invalidAmount;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enabled: !viewModel.isSubmitting,
    );
  }

  Widget _buildServiceDateField(
      BuildContext context, PaymentRecordViewModel viewModel) {
    return InkWell(
      onTap: viewModel.isSubmitting
          ? null
          : () async {
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
      child: FormField<DateTime>(
        initialValue: viewModel.serviceDate,
        validator: (value) {
          if (value == null) {
            return S.current.serviceDate;
          }
          return null;
        },
        builder: (FormFieldState<DateTime> state) {
          return InputDecorator(
            decoration: _getInputDecoration(
                    context, S.current.serviceDate, Icons.calendar_today)
                .copyWith(
              errorText: state.errorText,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat.yMMMEd().format(viewModel.serviceDate),
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onSurface),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          );
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }

  Widget _buildNotesField(
      BuildContext context, PaymentRecordViewModel viewModel) {
    return TextFormField(
      controller: viewModel.notesController,
      decoration:
          _getInputDecoration(context, S.current.notes, Icons.note).copyWith(
        alignLabelWithHint: true,
      ),
      textInputAction: TextInputAction.done,
      maxLines: 4,
      enabled: !viewModel.isSubmitting,
    );
  }

  void _showAddCustomerDialog(
      BuildContext context, PaymentRecordViewModel viewModel) {
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.person_add, color: Theme.of(context).primaryColor),
                  12.horizontalSpace,
                  Text(S.current.addNewCustomer),
                ],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: viewModel.customerNameController,
                        decoration: InputDecoration(
                          labelText: S.current.customerName,
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 16.h),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.current.errorEmptyField;
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        enabled: !viewModel.isAddingCustomer,
                      ),
                      32.verticalSpace,
                      TextFormField(
                        controller: viewModel.customerPhoneController,
                        decoration: InputDecoration(
                          labelText: S.current.phoneNumber,
                          prefixIcon: const Icon(Icons.phone),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 16.h),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.current.errorEmptyField;
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        enabled: !viewModel.isAddingCustomer,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: viewModel.isAddingCustomer
                      ? null
                      : () {
                          Navigator.of(context).pop();
                        },
                  child: Text(
                    S.current.cancel,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ),
                ElevatedButton(
                  onPressed: viewModel.isAddingCustomer
                      ? null
                      : () async {
                          if (formKey.currentState!.validate()) {
                            // Create a new customer
                            final newCustomer = CustomerModel(
                              id: '', // ID will be generated by the view model
                              name: viewModel.customerNameController.text,
                              phone: viewModel.customerPhoneController.text,
                            );

                            // Close the dialog first to avoid UI freezing
                            Navigator.of(context).pop();

                            // Add the customer
                            await viewModel.addCustomer(newCustomer);

                            // Clear the controllers after adding
                            viewModel.customerNameController.clear();
                            viewModel.customerPhoneController.clear();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: viewModel.isAddingCustomer
                      ? SizedBox(
                          height: 20.h,
                          width: 20.w,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.w,
                          ),
                        )
                      : Text(S.current.addCustomer),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
