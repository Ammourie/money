import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/ui/screens/base_view.dart';
import '../view_model/payment_record_view_model.dart';
import 'payment_record_view_content.dart';

class PaymentRecordViewParam {}

class PaymentRecordView extends BaseView<PaymentRecordViewParam> {
  static const routeName = "/PaymentRecordView";

  PaymentRecordView({required PaymentRecordViewParam param, Key? key})
      : super(param: param, key: key);

  @override
  _PaymentRecordViewState createState() => _PaymentRecordViewState();
}

class _PaymentRecordViewState extends State<PaymentRecordView> {
  late PaymentRecordViewModel paymentRecordModel;

  @override
  void initState() {
    super.initState();
    paymentRecordModel = PaymentRecordViewModel(widget.param);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: paymentRecordModel,
      builder: (context, _) {
        return const PaymentRecordViewContent();
      },
    );
  }

  /// Widget

  /// Logic

  @override
  void dispose() {
    paymentRecordModel.closeModel();
    super.dispose();
  }
}
