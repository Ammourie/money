import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class RequestWhenVisible extends StatelessWidget {
  const RequestWhenVisible({
    super.key,
    this.visibleFraction = 0.1,
    required this.visibilityKey,
    required this.requestCondition,
    required this.request,
    required this.child,
  });

  final double visibleFraction;
  final Key visibilityKey;
  final bool Function() requestCondition;
  final void Function() request;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: visibilityKey,
      onVisibilityChanged: (info) {
        if (info.visibleFraction >= visibleFraction &&
            requestCondition.call()) {
          request.call();
        }
      },
      child: child,
    );
  }
}
