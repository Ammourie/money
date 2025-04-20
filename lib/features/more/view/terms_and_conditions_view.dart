import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app/app_constants.dart';
import '../../../core/providers/session_data.dart';
import '../../../core/ui/screens/base_view.dart';
import '../../../core/ui/screens/empty_screen_wiget.dart';
import '../../../core/ui/widgets/custom_scaffold.dart';
import '../../../generated/l10n.dart';
import '../view_model/terms_and_conditions_view_model.dart';

class TermsAndConditionsViewParam {}

class TermsAndConditionsView extends BaseView<TermsAndConditionsViewParam> {
  const TermsAndConditionsView({super.key, required super.param});

  static const String routeName = "/TermsAndConditionsView";

  @override
  State<TermsAndConditionsView> createState() => _TermsAndConditionsViewState();
}

class _TermsAndConditionsViewState extends State<TermsAndConditionsView> {
  late TermsAndConditionsViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = TermsAndConditionsViewModel(widget.param);
  }

  @override
  Widget build(BuildContext context) {
    final data =
        context.read<SessionData>().homeInit?.termAndConditionsPage ?? '';

    return ChangeNotifierProvider.value(
      value: vm,
      child: CustomScaffold(
        appBar: AppBar(title: Text(S.current.termsAndConditions)),
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
