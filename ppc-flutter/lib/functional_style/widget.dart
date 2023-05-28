import 'package:flutter/cupertino.dart';

extension WidgetExtension on Widget {
  Expanded get expanded => Expanded(child: this);

  Padding margin(EdgeInsetsGeometry margin) => Padding(
        padding: margin,
        child: this,
      );
}
