import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../core/common/view_model/base_view_model.dart';
import '../../../core/params/page_param.dart';
import '../../../services/api_cubit/api_cubit.dart';
import '../model/response/faq_section_list_model.dart';
import '../view/faqs_view.dart';

class FaqsViewModel extends BaseViewModel<FaqsViewParam> {
  FaqsViewModel(super.param);
  final faqsCubit = ApiCubit();

  late List<FaqSectionModel> _faqSections;
  final refreshController = RefreshController();

  // set, get
  List<FaqSectionModel> get faqSections => _faqSections;
  set faqSections(List<FaqSectionModel> v) {
    _faqSections = v;
    if (hasListeners) notifyListeners();
  }

  // method
  void getFaqs() {
    faqsCubit.getFaqs(PageParam(page: 0));
  }

  @override
  void closeModel() {
    faqsCubit.close();
    refreshController.dispose();
    this.dispose();
  }
}
