import 'package:flutter/material.dart';
import 'package:simple_weight_tracker/src/presentation/styleguide/app_dimens.dart';

class BaseCard extends StatelessWidget {
  const BaseCard({
    required this.child,
    super.key,
    this.padding,
    this.height,
    this.width,
  });
  final Widget child;
  final EdgeInsets? padding;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.baseRadius),
        ),
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: child,
        ),
      ),
    );
  }
}
