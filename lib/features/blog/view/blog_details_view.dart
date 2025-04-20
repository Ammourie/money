import 'package:flutter/material.dart';
import 'package:slim_starter_application/core/ui/screens/base_view.dart';
import 'package:slim_starter_application/core/ui/widgets/custom_scaffold.dart';

class BlogDetailsViewParam {
  final int id;

  BlogDetailsViewParam({required this.id});
}

class BlogDetailsView extends BaseView<BlogDetailsViewParam> {
  const BlogDetailsView({super.key, required super.param});
  static const String routeName = "/BlogDetailsView";

  @override
  State<BlogDetailsView> createState() => _BlogDetailsViewState();
}

class _BlogDetailsViewState extends State<BlogDetailsView> {
  @override
  Widget build(BuildContext context) {
    return const CustomScaffold();
  }
}
