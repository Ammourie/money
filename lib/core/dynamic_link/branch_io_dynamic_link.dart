import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:mutex/mutex.dart';

class BranchIODynamicLink {
  static final branchIOLock = Mutex();

  static Future<void> init() async {
    await branchIOLock.acquire();
    await FlutterBranchSdk.init();

    FlutterBranchSdk.listSession().listen(
      (data) async {
        await branchIOLock.acquire();

        if (data.containsKey("+clicked_branch_link") &&
            data["+clicked_branch_link"] == true) {
          // int? productId = numV(data["product_id"]);
          // if (productId != null) {
          //   Nav.to(
          //     ProductDetailsScreen.routeName,
          //     arguments: ProductDetailsScreenParams(id: productId),
          //   );
          // }
        }

        branchIOLock.release();
      },
      onError: (error) {
        debugPrint('listSession error: ${error.toString()}');
      },
    );
  }

  // static Future<void> showShareProductSheet(
  //     ProductDetailsEntity product) async {
  //   final website = AppConfig()
  //       .appContext!
  //       .read<SessionData>()
  //       .homeEntity
  //       ?.storeConfigs
  //       ?.websiteUrl;
  //   final slug = product.slug;

  //   final buo = BranchUniversalObject(
  //     canonicalIdentifier: '$slug',
  //     canonicalUrl: '$website/$slug',
  //     title: product.name,
  //     imageUrl: product.mainImages.firstOrNull?.url ?? '',
  //     contentDescription: product.shortDescription,
  //     contentMetadata: BranchContentMetaData()
  //       ..addCustomMetadata('product_id', '${product.id}'),
  //   );

  //   BranchLinkProperties lp = BranchLinkProperties(feature: 'sharing')
  //     ..addControlParam('\$fallback_url', '$website/$slug');
  //   BranchResponse response =
  //       await FlutterBranchSdk.getShortUrl(buo: buo, linkProperties: lp);

  //   if (response.success) {
  //     await Share.shareUri(Uri.parse(response.result));
  //     debugPrint('Link generated: ${response.result}');
  //   } else {
  //     debugPrint('Error : ${response.errorCode} - ${response.errorMessage}');
  //   }
  // }
}
