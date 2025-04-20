import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:slim_starter_application/features/blog/model/response/blog_model.dart';
import 'package:slim_starter_application/features/blog/view/blog_details_view.dart';

import '../../../core/constants/app/app_constants.dart';
import '../../../core/navigation/nav.dart';
import '../../../core/ui/error_ui/errors_screens/error_widget.dart';
import '../../../core/ui/screens/base_view.dart';
import '../../../core/ui/widgets/custom_app_bar.dart';
import '../../../core/ui/widgets/custom_scaffold.dart';
import '../../../core/ui/widgets/waiting_widget.dart';
import '../../../generated/l10n.dart';
import '../../../services/api_cubit/api_cubit.dart';
import '../view_model/blog_list_view_model.dart';

class BlogListViewParam {}

class BlogListView extends BaseView<BlogListViewParam> {
  const BlogListView({super.key, required super.param});
  static const String routeName = "/BlogListView";

  @override
  State<BlogListView> createState() => _BlogListViewState();
}

class _BlogListViewState extends State<BlogListView> {
  late BlogListViewModel vm;
  @override
  void initState() {
    super.initState();
    vm = BlogListViewModel(widget.param);
    vm.getBlogs();
  }

  @override
  void dispose() {
    super.dispose();
    vm.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: vm,
      child: CustomScaffold(
        appBar: CustomAppBar(
          title: Text(S.current.blogs),
        ),
        body: BlocConsumer<ApiCubit, ApiState>(
          bloc: vm.blogsCubit,
          listener: (context, state) {
            state.maybeWhen(
              blogListLoaded: (data) {
                vm.blogs = [...data.items];
              },
              orElse: () {},
            );
          },
          builder: (context, state) {
            return state.maybeWhen(
              initial: () => const WaitingWidget(),
              loading: () => const WaitingWidget(),
              error: (error, callback) {
                return ErrorScreenWidget(error: error, callback: callback);
              },
              blogListLoaded: (_) => _buildBlogListContent(),
              orElse: () => const ScreenNotImplementedErrorWidget(),
            );
          },
        ),
      ),
    );
  }

  Padding _buildBlogListContent() {
    return Padding(
      padding: EdgeInsets.all(AppConstants.screenPadding),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          BlogModel blog = vm.blogs[index];
          return GestureDetector(
            onTap: () {
              if (blog.id != null)
                Nav.to(BlogDetailsView.routeName,
                    arguments: BlogDetailsViewParam(id: blog.id!));
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(blog.title),
            ),
          );
        },
        separatorBuilder: (context, index) => Divider(
          height: 2.h,
        ),
        itemCount: vm.blogs.length,
      ),
    );
  }
}
