import '../../../core/common/view_model/base_view_model.dart';
import '../view/terms_and_conditions_view.dart';

class TermsAndConditionsViewModel
    extends BaseViewModel<TermsAndConditionsViewParam> {
  TermsAndConditionsViewModel(super.param);

  @override
  void closeModel() {
    this.dispose();
  }
}
