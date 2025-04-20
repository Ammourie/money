import 'package:flutter/material.dart';
import '../../constants/app/app_constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.bottom,
    this.title,
    this.actions,
    this.backgroundColor,
    this.surfaceTintColor,
    this.shadowColor,
    this.foregroundColor,
    this.iconTheme,
    this.actionsIconTheme,
    this.toolbarHeight,
    this.elevation,
    this.shape,
    this.centerTitle,
  });
  final PreferredSizeWidget? bottom;
  final Widget? title;
  final List<Widget>? actions;
  final Color? backgroundColor, surfaceTintColor, shadowColor, foregroundColor;
  final IconThemeData? iconTheme, actionsIconTheme;
  final double? toolbarHeight, elevation;
  final ShapeBorder? shape;
  final bool? centerTitle;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      surfaceTintColor: surfaceTintColor,
      shadowColor: shadowColor,
      foregroundColor: foregroundColor,
      iconTheme: iconTheme,
      toolbarHeight: toolbarHeight,
      actionsIconTheme: actionsIconTheme,
      elevation: elevation,
      shape: shape,
      centerTitle: centerTitle,
      systemOverlayStyle: AppConstants.APP_BAR_OVERLAY_STYLE,
      bottom: bottom,
      title: title,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight ?? kToolbarHeight);
}
