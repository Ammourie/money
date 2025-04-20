import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/ui/screens/base_view.dart';
import '../view_model/home_view_model.dart';
import 'home_view_content.dart';

class HomeViewParam {}

class HomeView extends BaseView<HomeViewParam> {
  static const routeName = "/HomeView";

  HomeView({required HomeViewParam param, Key? key})
      : super(param: param, key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late HomeViewModel homeModel;

  @override
  void initState() {
    super.initState();
    homeModel = HomeViewModel(widget.param);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: homeModel,
      builder: (context, _) {
        return const HomeViewContent();
      },
    );
  }

  /// Widget

  /// Logic

  @override
  void dispose() {
    homeModel.closeModel();
    super.dispose();
  }
}
