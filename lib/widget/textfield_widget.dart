import 'package:flutter/material.dart';
import 'package:smart_parker/widget/stylefont_widget.dart';

Widget inputFieldPrimary(
    {required BuildContext context,
    String? hintText,
    TextEditingController? controller,
    Widget? leftWidget,
    Widget? rightWidget,
    bool? isHide,
    TextInputType? inputType,
    String? Function(String?)? validator}) {
  return TextFormField(
      keyboardType: inputType,
      obscureText: isHide ?? false,
      validator: validator,
      controller: controller,
      style: fontStyleParagraftBoldDefaultColor(context),
      decoration: InputDecoration(
        prefixIcon: leftWidget,
        suffixIcon: rightWidget,
        label: Text(
          hintText ?? "",
          style: fontStyleParagraftBoldDefaultColor(context),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ));
}
