import '../../../core/common/view_model/base_view_model.dart';
import '../view/contact_us_view.dart';

class ContactUsViewModel extends BaseViewModel<ContactUsViewParam> {
  ContactUsViewModel(super.param);

  @override
  void closeModel() {
    this.dispose();
  }
}
