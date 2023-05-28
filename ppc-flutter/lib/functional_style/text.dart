part of 'functional_style.dart';

class StyledText {
  Color? _color;
  final String value;

  StyledText([this.value = '']);

  StyledText color(Color color) => this.._color = color;

  Text child(String value) => Text(
        value,
        style: TextStyle(
          color: _color,
        ),
      );

  Text get render => child(value);
}

extension TextExtention on String {
  StyledText get text => StyledText(this);

  StyledButton get button => StyledButton(this);
}
