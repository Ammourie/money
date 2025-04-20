import '../../../../core/common/type_validators.dart';
import '../../../../core/constants/enums/banner_location_enum.dart';
import '../../../../core/constants/enums/link_to_type.dart';
import '../../../../core/constants/enums/media_type.dart';
import '../../../../core/models/base_model.dart';
import '../../../../core/models/file_model.dart';

class BannerModel extends BaseModel {
  final int? id;
  final BannerLocationEnum location;
  final String title;
  final String bannerTitle;
  final String bannerDescription;
  final FileModel? file;
  final MediaType mediaType;
  final LinkToType linkTo;
  final String linkedUrl;
  final String slug;

  BannerModel({
    required this.id,
    required this.location,
    required this.title,
    required this.bannerTitle,
    required this.bannerDescription,
    required this.file,
    required this.mediaType,
    required this.linkTo,
    required this.linkedUrl,
    required this.slug,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
        id: numV(json["id"]),
        location: BannerLocationEnum.mapToType(numV(json["location"])),
        title: stringV(json["currentTranslation"]?["title"]),
        bannerTitle: stringV(json["currentTranslation"]?["bannerTitle"]),
        bannerDescription:
            stringV(json["currentTranslation"]?["bannerDescription"]),
        file: json["currentTranslation"]?["file"] == null
            ? null
            : FileModel.fromJson(json["currentTranslation"]?["file"]),
        mediaType: MediaType.mapToType(numV(json["mediaType"])),
        linkTo: LinkToType.mapToType(numV(json["linkTo"])),
        linkedUrl: stringV(json["linkedUrl"]),
        slug: stringV(json["slug"]),
      );
}
