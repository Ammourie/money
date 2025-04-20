import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app/app_constants.dart';
import '../../../core/providers/session_data.dart';
import '../../../core/ui/screens/base_view.dart';
import '../../../core/ui/screens/empty_screen_wiget.dart';
import '../../../core/ui/widgets/custom_scaffold.dart';
import '../../../generated/l10n.dart';
import '../view_model/contact_us_view_model.dart';

class ContactUsViewParam {}

class ContactUsView extends BaseView<ContactUsViewParam> {
  const ContactUsView({super.key, required super.param});

  static const String routeName = "/ContactUsView";

  @override
  State<ContactUsView> createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView> {
  late ContactUsViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = ContactUsViewModel(widget.param);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: vm,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    final data = context.read<SessionData>().homeInit?.contactUsPage ?? '';
    return CustomScaffold(
      appBar: AppBar(title: Text(S.current.contactUs)),
      body: data.isEmpty
          ? const EmptyScreenWidget()
          : Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppConstants.screenPadding,
              ),
              child: HtmlWidget(data),
            ),
    );
  }

  @override
  void dispose() {
    vm.closeModel();
    super.dispose();
  }
}
