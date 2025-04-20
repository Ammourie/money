import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app/app_constants.dart';
import '../../../core/providers/session_data.dart';
import '../../../core/ui/screens/base_view.dart';
import '../../../core/ui/screens/empty_screen_wiget.dart';
import '../../../core/ui/widgets/custom_scaffold.dart';
import '../../../generated/l10n.dart';
import '../view_model/privacy_policy_view_model.dart';

class PrivacyPolicyViewParam {}

class PrivacyPolicyView extends BaseView<PrivacyPolicyViewParam> {
  const PrivacyPolicyView({super.key, required super.param});

  static const String routeName = "/PrivacyPolicyView";

  @override
  State<PrivacyPolicyView> createState() => _PrivacyPolicyViewState();
}

class _PrivacyPolicyViewState extends State<PrivacyPolicyView> {
  late PrivacyPolicyViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = PrivacyPolicyViewModel(widget.param);
  }

  @override
  Widget build(BuildContext context) {
    final data = context.read<SessionData>().homeInit?.privacyPolicyPage ?? '';

    return ChangeNotifierProvider.value(
      value: vm,
      child: CustomScaffold(
        appBar: AppBar(title: Text(S.current.privacyPolicy)),
        body: data.isEmpty
            ? const EmptyScreenWidget()
            : Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.screenPadding,
                ),
                child: HtmlWidget(data),
              ),
      ),
    );
  }

  @override
  void dispose() {
    vm.closeModel();
    super.dispose();
  }
}
