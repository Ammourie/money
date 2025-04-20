part of 'custom_search_dropdown.dart';

class _DropDownField<T> extends StatelessWidget {
  final GlobalKey<FormFieldState> dropdownKey;

  final T? value;
  final List<DropdownMenuItem<T>> items;
  final Widget? hint;
  final Widget? icon;
  final InputDecoration? decoration;
  final TextStyle? style;
  final VoidCallback onTap;
  final String? Function(T?)? validator;

  const _DropDownField({
    required this.dropdownKey,
    Key? key,
    this.value,
    required this.items,
    required this.onTap,
    this.validator,
    this.hint,
    this.icon,
    this.decoration,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (decoration?.enabled ?? true) == true ? onTap : null,
      child: AbsorbPointer(
        absorbing: (decoration?.enabled ?? true) == true ? true : false,
        child: DropdownButtonFormField<T>(
          key: dropdownKey,
          value: value,
          items: items,
          onChanged: (_) {},
          validator: validator,
          icon: icon,
          hint: hint,
          style: style,
          decoration: decoration,
          isExpanded: true,
        ),
      ),
    );
  }
}
