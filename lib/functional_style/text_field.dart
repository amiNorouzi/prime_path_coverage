part of 'functional_style.dart';

class StyledTextFiled extends FunctionalStyle<StyledTextFiled> {
  InputBorder? _border;
  String? _label;
  ValueChanged<String>? _onChange;
  EdgeInsetsGeometry? _padding;

  StyledTextFiled get outlined => this.._border = const OutlineInputBorder();

  StyledTextFiled label(String value) => this.._label = value;

  StyledTextFiled padding(EdgeInsetsGeometry value) => this.._padding = value;

  StyledTextFiled onChange(ValueChanged<String> value) =>
      this.._onChange = value;

  Widget get render {
    return build(
      TextField(
        onChanged: _onChange,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          isDense: true,
          border: _border,
          label: _label?.text.render,
          contentPadding: _padding,
        ),
      ),
    );
  }
}
