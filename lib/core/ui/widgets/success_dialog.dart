import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';

import '../../../generated/l10n.dart';
import '../../common/app_config.dart';
import '../../constants/app/app_constants.dart';
import '../../constants/enums/success_dialog_type.dart';
import '../../navigation/nav.dart';

/// Shows a modern success dialog with animations and theming options
void showSuccessDialog({
  VoidCallback? onButtonPressed,
  required String title,
  required String content,
  String? buttonText,
  Color accentColor = const Color(0xFF00BFA5), // Default teal accent
  SuccessDialogType type = SuccessDialogType.type1,
  bool showConfetti = false,
}) {
  showGeneralDialog(
    context: AppConfig().appContext!,
    barrierDismissible: true,
    barrierLabel: "Success Dialog",
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (context, animation1, animation2) => Container(), // Not used
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutBack,
      );

      return ScaleTransition(
        scale: curvedAnimation,
        child: FadeTransition(
          opacity: animation,
          child: ModernSuccessDialog(
            onPressed: onButtonPressed,
            content: content,
            title: title,
            buttonText: buttonText,
            accentColor: accentColor,
            type: type,
            showConfetti: showConfetti,
          ),
        ),
      );
    },
  );
}

class ModernSuccessDialog extends StatelessWidget {
  const ModernSuccessDialog({
    Key? key,
    this.onPressed,
    required this.title,
    required this.content,
    this.buttonText,
    this.accentColor = const Color(0xFF00BFA5),
    this.type = SuccessDialogType.type1,
    this.showConfetti = false,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final String title, content;
  final String? buttonText;
  final Color accentColor;
  final SuccessDialogType type;
  final bool showConfetti;

  @override
  Widget build(BuildContext context) {
    final screenWidth = 1.sw;
    final maxWidth = screenWidth * 0.85;

    return Center(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Dialog(
          backgroundColor: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          insetPadding: EdgeInsets.symmetric(
            horizontal: AppConstants.screenPadding,
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: maxWidth,
              minWidth: 300,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 24.w,
              vertical: 32.h,
            ),
            child: type == SuccessDialogType.type1
                ? _buildType1Content(context)
                : _buildType2Content(context),
          ),
        ),
      ),
    );
  }

  Widget _buildType1Content(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildSuccessIconWithAnimation(),
        20.verticalSpace,
        _buildTitle(alignment: CrossAxisAlignment.start, context: context),
        20.verticalSpace,
        _buildContent(context: context),
        36.verticalSpace,
        _buildActionButton(context: context),
      ],
    );
  }

  Widget _buildType2Content(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSuccessIconWithAnimation(),
        28.verticalSpace,
        _buildTitle(alignment: CrossAxisAlignment.center, context: context),
        20.verticalSpace,
        _buildContent(context: context),
        36.verticalSpace,
        _buildActionButton(context: context),
      ],
    );
  }

  Widget _buildSuccessIconWithAnimation() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: 175.sp,
            height: 175.sp,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: 125.sp,
                height: 125.sp,
                decoration: BoxDecoration(
                  color: accentColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 70.sp,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle(
      {required CrossAxisAlignment alignment, required BuildContext context}) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
          textAlign: type == SuccessDialogType.type1
              ? TextAlign.start
              : TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildContent({required BuildContext context}) {
    return Text(
      content,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.black54,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
      textAlign:
          type == SuccessDialogType.type1 ? TextAlign.start : TextAlign.center,
    );
  }

  Widget _buildActionButton({required BuildContext context}) {
    return SizedBox(
      width: type == SuccessDialogType.type1 ? 0.5.sw : double.infinity,
      child: ElevatedButton(
        onPressed: onPressed ?? () => Nav.pop(),
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          buttonText ?? S.current.close,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}

/// Optional animation component for confetti effect
class SuccessConfetti extends StatefulWidget {
  const SuccessConfetti({Key? key}) : super(key: key);

  @override
  State<SuccessConfetti> createState() => _SuccessConfettiState();
}

class _SuccessConfettiState extends State<SuccessConfetti>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Implement confetti animation here
    return Container();
  }
}
