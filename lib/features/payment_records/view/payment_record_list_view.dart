import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/ui/screens/base_view.dart';

import '../view_model/payment_record_list_view_model.dart';
import 'payment_record_list_content_view.dart';

class PaymentRecordListViewParam {
  PaymentRecordListViewParam();
}

class PaymentRecordListView extends BaseView<PaymentRecordListViewParam> {
  static const routeName = "/PaymentRecordListView";

  PaymentRecordListView({required PaymentRecordListViewParam param, Key? key})
      : super(param: param, key: key);

  @override
  _PaymentRecordListViewState createState() => _PaymentRecordListViewState();
}

class _PaymentRecordListViewState extends State<PaymentRecordListView> {
  late PaymentRecordListViewModel paymentRecordListModel;

  @override
  void initState() {
    super.initState();
    paymentRecordListModel = PaymentRecordListViewModel(widget.param);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: paymentRecordListModel,
      builder: (context, _) {
        return const PaymentRecordListViewContent();
      },
    );
  }

  @override
  void dispose() {
    paymentRecordListModel.closeModel();
    super.dispose();
  }
}
