import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {
  final ValueChanged<bool>? onChanged;
  final bool value;
  final Color? activeColor;
  final Color? inactiveColor;

  const CustomSwitch({
    Key? key,
    this.onChanged,
    required this.value,
    this.activeColor,
    this.inactiveColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: Material(
        child: InkWell(
          onTap: onChanged == null
              ? null
              : () {
                  onChanged!.call(!value);
                },
          splashFactory: NoSplash.splashFactory,
          child: Stack(
            children: [
              Container(
                height: 80,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.0),
                  color: Colors.white,
                  border: Border.all(
                    color: value
                        ? activeColor ?? Theme.of(context).colorScheme.secondary
                        : inactiveColor ?? Theme.of(context).disabledColor,
                    width: 13,
                  ),
                ),
              ),
              AnimatedPositionedDirectional(
                end: value ? 0 : 70,
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    color: value
                        ? activeColor ?? Theme.of(context).colorScheme.secondary
                        : inactiveColor ?? Theme.of(context).disabledColor,
                  ),
                ),
                duration: const Duration(milliseconds: 500),
                curve: Curves.bounceOut,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
