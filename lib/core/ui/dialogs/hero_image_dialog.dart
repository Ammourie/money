import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/app_config.dart';
import '../../navigation/animations/hero_dialog_route.dart';
import '../../navigation/nav.dart';
import '../widgets/custom_image.dart';

void showHeroImageDialog(String imageUrl, String heroTag) {
  Navigator.push(
    AppConfig().appContext!,
    HeroDialogRoute(
      builder: (context) {
        return _ImageDialog(heroTag: heroTag, imageUrl: imageUrl);
      },
    ),
  );
}

class _ImageDialog extends StatefulWidget {
  _ImageDialog({
    Key? key,
    required this.imageUrl,
    required this.heroTag,
  }) : super(key: key);

  final String imageUrl, heroTag;

  @override
  State<_ImageDialog> createState() => __ImageDialogState();
}

class __ImageDialogState extends State<_ImageDialog> {
  Offset _clickPostion = Offset.zero;
  Offset _currentPostion = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: _currentPostion,
      child: Center(
        child: Hero(
          tag: widget.heroTag,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 0.5.sh, maxHeight: 0.8.sh),
            child: InteractiveViewer(
              clipBehavior: Clip.none,
              onInteractionStart: (details) {
                _clickPostion = details.localFocalPoint;
              },
              onInteractionEnd: (details) {
                if (details.pointerCount == 0) {
                  if (details.velocity.pixelsPerSecond.dy > 1000 ||
                      details.velocity.pixelsPerSecond.dy < -1000) {
                    Nav.pop();
                    return;
                  }
                  setState(() {
                    _clickPostion = Offset.zero;
                    _currentPostion = Offset.zero;
                  });
                }
              },
              onInteractionUpdate: (details) {
                setState(() {
                  _currentPostion =
                      Offset(0, details.localFocalPoint.dy - _clickPostion.dy);
                });
              },
              child: CustomImage.network(
                widget.imageUrl,
                width: 1.0.sw,
                // fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
