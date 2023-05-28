part of 'functional_style.dart';

extension EdgeInsetsExtension on num {
  EdgeInsets get edgeInsetsAll => EdgeInsets.all(toDouble());

  EdgeInsets get edgeInsetsX => EdgeInsets.symmetric(horizontal: toDouble());

  EdgeInsets get edgeInsetsY => EdgeInsets.symmetric(vertical: toDouble());

  EdgeInsets get edgeInsetsT => EdgeInsets.only(top: toDouble());

  EdgeInsets get edgeInsetsB => EdgeInsets.only(bottom: toDouble());

  EdgeInsetsDirectional get edgeInsetsS =>
      EdgeInsetsDirectional.only(start: toDouble());

  EdgeInsetsDirectional get edgeInsetsE =>
      EdgeInsetsDirectional.only(end: toDouble());
}
