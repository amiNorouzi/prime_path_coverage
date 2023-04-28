import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part 'button.dart';

part 'edge_insets_extension.dart';

part 'text.dart';

part 'text_field.dart';

abstract class FunctionalStyle<T> {
  static StyledText get text => StyledText();

  static StyledTextFiled get textFiled => StyledTextFiled();

  static StyledButton get button => StyledButton();

  int _flex = 1;
  bool _expanded = false;
  EdgeInsetsGeometry? _margin;

  double? _width;
  double? _height;

  T flex(int flex) => (this.._flex = flex) as T;

  T get expanded => (this.._expanded = true) as T;

  T margin(EdgeInsetsGeometry m) => (this.._margin = m) as T;

  T width(num w) => (this.._width = w.toDouble()) as T;

  T height(num h) => (this.._height = h.toDouble()) as T;

  Widget build(Widget child) {
    Widget view = Container(
      width: _width,
      height: _height,
      margin: _margin,
      child: child,
    );
    if (_expanded) view = Expanded(flex: _flex, child: view);

    return view;
  }
}
