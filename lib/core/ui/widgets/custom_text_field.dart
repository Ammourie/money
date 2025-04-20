import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app/app_constants.dart';

class CurserSettings {
  final double cursorWidth;
  final double? cursorHeight;
  final Color? cursorColor;
  final Radius? cursorRadius;
  final bool? showCursor;

  const CurserSettings({
    this.cursorWidth = 2,
    this.cursorHeight,
    this.cursorColor,
    this.cursorRadius,
    this.showCursor,
  });
}

class CustomTextField extends StatefulWidget {
  CustomTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.decoration = const InputDecoration(),
    this.style,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.textAlignVertical,
    this.textCapitalization = TextCapitalization.none,
    this.curserSettings = const CurserSettings(),
    this.customCountryCode,
    this.customVisiblityIcon,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.maxLines = 1,
    this.maxLength,
    this.useDecorationOnly = false,
    this.enabled = true,
    this.expands = false,
    this.readOnly = false,
  });

  final bool enabled;
  final bool expands;
  final bool readOnly;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextStyle? style;
  final TextAlign textAlign;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final InputDecoration decoration;
  final bool useDecorationOnly;
  final Widget? customCountryCode;
  final Widget? customVisiblityIcon;
  final int? maxLines;
  final int? maxLength;
  final CurserSettings curserSettings;
  final TextDirection? textDirection;
  final TextAlignVertical? textAlignVertical;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function(String)? onFieldSubmitted;
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final key = GlobalKey<FormFieldState>();
  late final InputBorder? border;
  late final InputBorder? enabledBorder;

  bool obscureText = false;
  bool isFilled = false;

  @override
  void initState() {
    super.initState();
    obscureText = widget.keyboardType == TextInputType.visiblePassword;
    isFilled = widget.controller?.text.isNotEmpty ?? false;

    border = widget.decoration.border;
    enabledBorder = widget.decoration.enabledBorder;
  }

  @override
  void didUpdateWidget(covariant CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != null)
      isFilled = widget.controller!.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: key,
      enabled: widget.enabled,
      expands: widget.expands,
      readOnly: widget.readOnly,
      textDirection: widget.textDirection,
      controller: widget.controller,
      focusNode: widget.focusNode,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      style: widget.style,
      inputFormatters: widget.inputFormatters,
      autofillHints: widget.keyboardType == TextInputType.phone
          ? [AutofillHints.telephoneNumberNational]
          : widget.keyboardType == TextInputType.visiblePassword
              ? [AutofillHints.password]
              : null,
      decoration: widget.useDecorationOnly
          ? widget.decoration
          : widget.decoration.copyWith(
              isDense: true,
              filled: true,
              border: isFilled
                  ? widget.decoration.border
                  : widget.decoration.border,
              enabledBorder: isFilled
                  ? widget.decoration.enabledBorder
                  : widget.decoration.enabledBorder,
              prefixIcon: (widget.keyboardType == TextInputType.phone &&
                      Directionality.of(context) == TextDirection.ltr)
                  ? _buildCountryCode()
                  : widget.decoration.prefixIcon,
              suffixIcon: (widget.keyboardType == TextInputType.visiblePassword)
                  ? _buildVisibiltyIcon()
                  : (widget.keyboardType == TextInputType.phone &&
                          Directionality.of(context) == TextDirection.rtl)
                      ? _buildCountryCode()
                      : widget.decoration.suffixIcon,
              errorMaxLines: 2,
            ),
      validator: widget.validator,
      onChanged: (value) {
        key.currentState?.validate();
        if (isFilled != value.isNotEmpty) {
          setState(() => isFilled = value.isNotEmpty);
          print(isFilled);
        }

        widget.onChanged?.call(value);
      },
      onTap: widget.onTap,
      onFieldSubmitted: widget.onFieldSubmitted,
      obscureText: obscureText,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      textAlign: widget.textAlign,
      cursorWidth: widget.curserSettings.cursorWidth,
      cursorHeight: widget.curserSettings.cursorHeight,
      cursorColor: widget.curserSettings.cursorColor,
      cursorRadius: widget.curserSettings.cursorRadius,
      showCursor: widget.curserSettings.showCursor,
      textAlignVertical: widget.textAlignVertical,
      textCapitalization: widget.textCapitalization,
    );
  }

  Widget _buildCountryCode() {
    return widget.customCountryCode ??
        Align(
          alignment: Alignment.center,
          widthFactor: 1.0,
          heightFactor: 1.0,
          child: Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${AppConstants.COUNTRY_CODE}  ",
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0,
                    ),
                    textDirection: TextDirection.ltr,
                  ),
                  SizedBox(
                    height: 32.h,
                    child: VerticalDivider(
                      width: 0,
                      color: Colors.grey.shade300,
                      thickness: 1,
                    ),
                  ),
                  10.horizontalSpace,
                ],
              ),
            ),
          ),
        );
  }

  Widget _buildVisibiltyIcon() {
    return widget.customVisiblityIcon ??
        Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: Container(
            width: 50.w,
            height: 50.w,
            padding: const EdgeInsets.all(5),
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () => setState(() => obscureText = !obscureText),
              child: Icon(
                obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 50.w,
                color: Colors.grey.shade900,
              ),
            ),
          ),
        );
  }
}
