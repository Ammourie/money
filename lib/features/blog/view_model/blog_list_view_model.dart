import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../core/common/view_model/base_view_model.dart';
import '../../../core/navigation/nav.dart';
import '../../../core/params/page_param.dart';
import '../../../services/api_cubit/api_cubit.dart';
import '../model/response/blog_model.dart';
import '../view/blog_details_view.dart';
import '../view/blog_list_view.dart';

class BlogListViewModel extends BaseViewModel<BlogListViewParam> {
  BlogListViewModel(super.param);

  final blogsCubit = ApiCubit();
  final refreshController = RefreshController();
  late List<BlogModel> _blogs;

  // set, get
  List<BlogModel> get blogs => _blogs;
  set blogs(List<BlogModel> v) {
    _blogs = v;
    if (hasListeners) notifyListeners();
  }

  // methods
  void getBlogs() {
    blogsCubit.getBlogs(PageParam(page: 0));
  }

  void onBlogTap(int index) {
    if (blogs[index].id != null) {
      Nav.to(
        BlogDetailsView.routeName,
        arguments: BlogDetailsViewParam(id: blogs[index].id!),
      );
    }
  }

  @override
  void closeModel() {
    blogsCubit.close();
  }
}
