import '../../../core/common/view_model/base_view_model.dart';
import '../view/about_us_view.dart';

class AboutUsViewModel extends BaseViewModel<AboutUsViewParam> {
  AboutUsViewModel(super.param);

  @override
  void closeModel() {
    this.dispose();
  }
}
