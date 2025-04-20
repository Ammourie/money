import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app/app_constants.dart';
import '../../../core/providers/session_data.dart';
import '../../../core/ui/screens/base_view.dart';
import '../../../core/ui/screens/empty_screen_wiget.dart';
import '../../../core/ui/widgets/custom_scaffold.dart';
import '../../../generated/l10n.dart';
import '../view_model/about_us_view_model.dart';

class AboutUsViewParam {}

class AboutUsView extends BaseView<AboutUsViewParam> {
  const AboutUsView({super.key, required super.param});

  static const String routeName = "/AboutUsView";

  @override
  State<AboutUsView> createState() => _AboutUsViewState();
}

class _AboutUsViewState extends State<AboutUsView> {
  late AboutUsViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = AboutUsViewModel(widget.param);
  }

  @override
  Widget build(BuildContext context) {
    final data = context.read<SessionData>().homeInit?.aboutUsPage ?? '';

    return ChangeNotifierProvider.value(
      value: vm,
      child: CustomScaffold(
        appBar: AppBar(title: Text(S.current.aboutUs)),
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
