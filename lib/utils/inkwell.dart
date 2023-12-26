import 'package:flutter/material.dart';

class MInkWell extends StatelessWidget {
  final double? width;
  final double? height;
  final double? borderRadius;
  final BorderSide? borderSide;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Widget? child;
  final void Function()? onTap;
  final void Function()? onTapDown;
  final void Function()? onTapCancel;
  final Color? color;
  final Color? colorPressed;
  final Color? colorDisabled;
  final bool disabled;

  const MInkWell({
    Key? key,
    this.width,
    this.height,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.child,
    this.onTap,
    this.onTapDown,
    this.onTapCancel,
    this.color,
    this.colorPressed,
    this.colorDisabled,
    this.disabled = false,
    this.borderSide,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widgetColor = color ?? Colors.transparent;
    return Container(
      margin: margin,
      child: SizedBox(
        height: height,
        width: width,
        child: Material(
          color: disabled ? colorDisabled ?? widgetColor.withOpacity(0.4) : widgetColor,
          shape: RoundedRectangleBorder(
            side: borderSide ?? BorderSide.none,
            borderRadius: BorderRadius.circular(borderRadius ?? 4),
          ),
          child: Ink(
            child: InkWell(
              borderRadius: BorderRadius.circular(borderRadius ?? 4),
              onTap: disabled ? null : onTap,
              onTapDown: !disabled && onTapDown != null ? (_) => onTapDown?.call() : null,
              onTapUp: (_) => onTapCancel?.call(),
              onTapCancel: onTapCancel,
              highlightColor: colorPressed,
              child: Padding(
                padding: padding,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
