part of 'functional_style.dart';

class StyledButton {
  VoidCallback? _onPressed;
  final dynamic value;

  StyledButton([this.value = '']);

  StyledButton onPressed(VoidCallback callback) => this.._onPressed = callback;

  Widget child(value) {
    if (value.runtimeType == IconData) {
      return IconButton(
        onPressed: _onPressed,
        icon: Icon(value),
      );
    }
    return TextButton(
      onPressed: _onPressed,
      child: Text(value.toString()),
    );
  }

  Widget get render => child(value);
}

extension IconDataExtension on IconData{
  StyledButton get button => StyledButton(this);
}
