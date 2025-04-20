import '../../../../core/models/base_model.dart';
import '../../../account/model/response/profile_model.dart';
import '../../../home/model/response/home_init_model.dart';

class SplashModel extends BaseModel {
  final ProfileModel? profile;
  final HomeInitModel? homeInit;

  SplashModel({
    required this.homeInit,
    required this.profile,
  });
}
