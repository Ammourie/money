import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../generated/l10n.dart';
import '../../../../errors/app_errors.dart';
import '../../../../results/result.dart';
import 'cubit/item_list_cubit.dart';

part 'animated_section.dart';
part 'dropdown_field.dart';
part 'dropdown_overlay.dart';
part 'overlay_builder.dart';

class DropdownController {
  final bool loadingItemOnBuild;

  late final ItemListCubit? itemListCubit;

  DropdownController({this.loadingItemOnBuild = true});
}

class CustomSearchDropdown<T> extends StatefulWidget {
  final bool enabled;
  final bool enableSearch;
  final DropdownController? controller;
  final T? initValue;
  final List<T>? items;
  final Future<Result<AppErrors, List<T>>>? Function()? fetchItemsFromAPI;
  final TextStyle? style;
  final String Function(T) getStringFromItem;
  final VoidCallback? onTap;
  final ValueChanged<T?> onChanged;
  final Widget? hint;
  final Widget? menuHint;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? disabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final InputBorder? focusedErrorBorder;
  final double? menuBorderRadius;
  final Widget icon;
  final Widget? prefixIcon;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry menuHeaderPadding;
  final EdgeInsetsGeometry menuItemsPadding;
  final EdgeInsetsGeometry overlayOuterPadding;
  final Color? menuBackgroundColor;
  final Color? menuIconColor;
  final VoidCallback? onSearchTap;
  final String? Function(T?)? validator;
  final TextStyle? errorStyle;
  final TextStyle? searchTextStyle;
  final FocusNode? searchFocusNode;

  CustomSearchDropdown({
    Key? key,
    this.controller,
    this.initValue,
    this.enabled = true,
    this.enableSearch = true,
    this.items,
    this.fetchItemsFromAPI,
    required this.getStringFromItem,
    required this.onChanged,
    this.onTap,
    this.hint,
    this.menuHint,
    this.border,
    this.enabledBorder,
    this.disabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.focusedErrorBorder,
    this.menuBorderRadius,
    this.icon =
        const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black),
    this.prefixIcon,
    this.fillColor = Colors.white,
    this.contentPadding,
    this.menuHeaderPadding =
        const EdgeInsets.only(left: 16.0, top: 16, bottom: 16, right: 14),
    this.menuItemsPadding =
        const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    this.overlayOuterPadding =
        const EdgeInsets.only(bottom: 12, left: 5, right: 5),
    this.menuBackgroundColor,
    this.menuIconColor,
    this.onSearchTap,
    this.validator,
    this.style,
    this.errorStyle,
    this.searchTextStyle,
    this.searchFocusNode,
  })  : assert((items == null) ^ (fetchItemsFromAPI == null)),
        super(key: key);

  @override
  State<CustomSearchDropdown<T>> createState() =>
      _CustomSearchDropdownState<T>();
}

class _CustomSearchDropdownState<T> extends State<CustomSearchDropdown<T>> {
  final layerLink = LayerLink();
  final _selectValueNotifier = ValueNotifier<T?>(null);
  late List<T> _items;
  bool _isLoading = false, _isError = false;
  ItemListCubit<T>? _itemListCubit;
  final _dropdownKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();
    _items = widget.items ?? [];
    if (widget.fetchItemsFromAPI != null) {
      _itemListCubit = ItemListCubit<T>(() => widget.fetchItemsFromAPI!()!);
      if (widget.controller?.loadingItemOnBuild ?? true)
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _itemListCubit!.fetchItems();
        });
      if (widget.controller != null)
        widget.controller!.itemListCubit = _itemListCubit;
    } else {
      if (widget.initValue != null) {
        _selectValueNotifier.value = widget.initValue;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_itemListCubit != null) {
      return BlocListener<ItemListCubit<T>, ItemListState<T>>(
        bloc: _itemListCubit,
        listener: (_, state) {
          state.maybeWhen(
            loading: () {
              setState(() {
                _isLoading = true;
              });
            },
            error: (error, callback) {
              setState(() {
                _isLoading = false;
                _isError = true;
              });
            },
            loaded: (data) {
              _isLoading = false;
              _isError = false;
              setState(() {
                _items = data;
              });
              _selectValueNotifier.value = widget.initValue;
            },
            orElse: () {},
          );
        },
        child: _buildDropdown(),
      );
    }
    return _buildDropdown();
  }

  @override
  void didUpdateWidget(covariant CustomSearchDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _selectValueNotifier.value = widget.initValue;
  }

  Widget _buildDropdown() {
    return _OverlayBuilder(
      overlay: (size, hideCallback) {
        return _DropdownOverlay<T>(
          enableSearch: widget.enableSearch,
          selectValueNotifier: _selectValueNotifier,
          items: _getDropdownItems(),
          getStringFromItem: widget.getStringFromItem,
          onChanged: (value) {
            widget.onChanged.call(value);
            // wait until dropdown set new value then make validate.
            Future.delayed(const Duration(milliseconds: 100), () {
              _dropdownKey.currentState?.validate();
            });
          },
          size: size,
          layerLink: layerLink,
          hideOverlay: hideCallback,
          headerHint: widget.menuHint,
          canCloseOutsideBounds: true,
          borderRadius: widget.menuBorderRadius,
          listItemPadding: widget.menuItemsPadding,
          headerPadding: widget.menuHeaderPadding,
          overlayOuterPadding: widget.overlayOuterPadding,
          onSearchTap: widget.onSearchTap,
          backgroundColor: widget.menuBackgroundColor,
          iconColor: widget.menuIconColor,
          searchTextStyle: widget.searchTextStyle,
          searchFocusNode: widget.searchFocusNode,
        );
      },
      child: (showCallback) {
        return CompositedTransformTarget(
          link: layerLink,
          child: _DropDownField(
            dropdownKey: _dropdownKey,
            value: _selectValueNotifier.value,
            items: _getDropdownItems(),
            onTap: () {
              showCallback.call();
              widget.onTap?.call();
            },
            validator: widget.validator,
            icon: _isLoading
                ? _loadingIcon
                : _isError
                    ? _errorButton
                    : widget.icon,
            hint: _isError
                ? Text(
                    S.current.errorOccurred,
                    style: TextStyle(color: Colors.red, fontSize: 38.sp),
                  )
                : widget.hint,
            decoration: InputDecoration(
              enabled: !(_isLoading || _isError) && widget.enabled,
              border: widget.border,
              enabledBorder: _selectValueNotifier.value != null
                  ? widget.focusedBorder
                  : widget.enabledBorder,
              disabledBorder: widget.disabledBorder,
              focusedBorder: widget.focusedBorder,
              errorBorder: widget.errorBorder,
              focusedErrorBorder: widget.focusedErrorBorder,
              fillColor: widget.fillColor,
              filled: widget.fillColor != null,
              contentPadding: widget.contentPadding,
              errorStyle: widget.errorStyle,
              errorMaxLines: 2,
              prefixIcon: widget.prefixIcon,
            ),
          ),
        );
      },
    );
  }

  List<DropdownMenuItem<T>> _getDropdownItems() {
    return _items
        .map(
          (item) => DropdownMenuItem<T>(
            value: item,
            child: Text(
              widget.getStringFromItem.call(item),
              style: widget.style,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
        .toList();
  }

  SizedBox get _loadingIcon => SizedBox(
        width: 50.w,
        height: 50.w,
        child: const CircularProgressIndicator(strokeWidth: 3),
      );
  InkWell get _errorButton => InkWell(
        onTap: () {
          print("error");
          _itemListCubit!.fetchItems();
        },
        child: Icon(Icons.replay, size: 60.w, color: Colors.red),
      );

  @override
  void dispose() {
    _selectValueNotifier.dispose();
    super.dispose();
  }
}
