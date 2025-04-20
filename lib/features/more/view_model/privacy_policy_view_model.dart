import '../../../core/common/view_model/base_view_model.dart';
import '../view/privacy_policy_view.dart';

class PrivacyPolicyViewModel extends BaseViewModel<PrivacyPolicyViewParam> {
  PrivacyPolicyViewModel(super.param);

  @override
  void closeModel() {
    this.dispose();
  }
}
