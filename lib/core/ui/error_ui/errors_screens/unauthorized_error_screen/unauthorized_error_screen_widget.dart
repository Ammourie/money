part of '../error_widget.dart';

class UnauthorizedErrorScreenWidget extends StatefulWidget {
  @override
  _UnauthorizedErrorScreenWidgetState createState() =>
      _UnauthorizedErrorScreenWidgetState();
}

class _UnauthorizedErrorScreenWidgetState
    extends State<UnauthorizedErrorScreenWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildErrorScreen(
      callback: null,
      context: context,
      disableRetryButton: false,
      title: S.current.unauthorized,
      imageUrl: AppConstants.ERROR_403_401,
      errorAnimation: ErrorAnimation(
        animUrl: AppConstants.ANIM_LOTTIE_ERROR_403_401,
        animationController: _controller,
      ),
    );
  }
}
