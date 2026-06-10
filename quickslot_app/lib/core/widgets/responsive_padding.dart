import 'package:flutter/material.dart';
import 'package:quickslot_app/core/utils/responsive_utils.dart';

class ResponsivePadding extends StatelessWidget {
  const ResponsivePadding({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveUtils.horizontalPadding(
      MediaQuery.sizeOf(context).width,
    );

    return Padding(
      padding: EdgeInsets.all(padding),
      child: child,
    );
  }
}
