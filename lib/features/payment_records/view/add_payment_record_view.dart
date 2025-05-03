import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/ui/screens/base_view.dart';
import '../../../generated/l10n.dart';
import '../view_model/add_payment_record_view_model.dart';
import 'add_payment_record_view_content.dart';

class AddPaymentRecordViewParam {}

class AddPaymentRecordView extends BaseView<AddPaymentRecordViewParam> {
  static const routeName = "/AddPaymentRecordView";

  AddPaymentRecordView({required AddPaymentRecordViewParam param, Key? key})
      : super(param: param, key: key);

  @override
  _AddPaymentRecordViewState createState() => _AddPaymentRecordViewState();
}

class _AddPaymentRecordViewState extends State<AddPaymentRecordView> {
  late AddPaymentRecordViewModel paymentRecordModel;

  @override
  void initState() {
    super.initState();
    paymentRecordModel = AddPaymentRecordViewModel(widget.param);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: paymentRecordModel,
      builder: (context, _) {
        return WillPopScope(
          onWillPop: () async {
            // Handle back button press - ask for confirmation if there's unsaved data
            if (_hasUnsavedChanges()) {
              return await _showDiscardChangesDialog(context) ?? true;
            }
            return true;
          },
          child: const AddPaymentRecordViewContent(),
        );
      },
    );
  }

  /// Check if there are unsaved changes
  bool _hasUnsavedChanges() {
    // Check if any field has been filled but not submitted
    return (paymentRecordModel.serviceName.isNotEmpty ||
            paymentRecordModel.serviceCost > 0 ||
            paymentRecordModel.notes.isNotEmpty) &&
        paymentRecordModel.selectedCustomer != null;
  }

  /// Show dialog to confirm discarding changes
  Future<bool?> _showDiscardChangesDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.current.discardChanges),
          content: Text(
            S.current.unsavedChangesConfirmation,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(false), // Stay on screen
              child: Text(S.current.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Allow pop
              child: Text(S.current.discard),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    paymentRecordModel.closeModel();
    super.dispose();
  }
}
