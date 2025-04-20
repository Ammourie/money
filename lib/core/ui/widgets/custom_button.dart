import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Size? fixedSize;
  final Widget child;
  final Color backgroundColor;
  final Color primary;
  final Color shadowColor;
  final double elevation;
  final Radius borderRadius;
  final void Function()? onPressed;
  final EdgeInsetsGeometry padding;
  final bool hasBorder;
  final Color borderColor;
  final double borderWidth;

  const CustomButton({
    Key? key,
    this.fixedSize,
    required this.child,
    this.backgroundColor = Colors.blue,
    this.primary = Colors.white,
    this.shadowColor = Colors.transparent,
    this.elevation = 0.0,
    this.borderRadius = const Radius.circular(10.0),
    this.onPressed,
    this.padding = EdgeInsets.zero,
    this.hasBorder = false,
    this.borderColor = Colors.transparent,
    this.borderWidth = 1.5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (fixedSize?.width ?? 0) > 0 ? fixedSize?.width : null,
      height: (fixedSize?.height ?? 0) > 0 ? fixedSize?.height : null,
      child: TextButton(
        onPressed: onPressed,
        child: child,
        style: TextButton.styleFrom(
          padding: padding,
          foregroundColor: primary,
          backgroundColor: backgroundColor,
          elevation: elevation,
          shadowColor: shadowColor,
          side: hasBorder
              ? BorderSide(
                  color: borderColor,
                  width: borderWidth,
                  style: BorderStyle.solid,
                )
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(borderRadius),
          ),
        ),
      ),
    );
  }
}
