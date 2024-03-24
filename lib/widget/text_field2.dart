import 'package:dream_home/global/ui_helper.dart';
import 'package:flutter/material.dart';

class CustomTextField2 extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final bool autocorrect;
  final GestureTapCallback? onTap;
  final int? maxLines;
  final int? maxLength;

  const CustomTextField2({
    super.key,
    this.controller,
    this.hintText,
    required this.labelText,
    this.helperText,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.autocorrect = true,
    this.onTap,
    this.maxLines = 1,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      autocorrect: autocorrect,
      onTap: onTap,
      maxLines: maxLines,
      maxLength: maxLength,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        helperText: helperText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide(color: MyColors.green3),
        ),
        hintStyle: TextStyle(
          fontFamily: "nunito",
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade500,
          fontSize: 13.0,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        labelStyle: TextStyle(
          fontFamily: "nunito",
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade700,
          fontSize: 13.0,
        ),
        helperStyle: TextStyle(
          color: Colors.grey.shade500,
          fontFamily: "nunito",
          fontSize: 11.5,
        ),
        floatingLabelStyle: TextStyle(
          fontFamily: "nunito",
          fontWeight: FontWeight.bold,
          color: MyColors.green2,
          fontSize: 17.0,
        ),
      ),
      scrollPhysics: const BouncingScrollPhysics(),
      cursorRadius: const Radius.circular(50.0),
      cursorColor: MyColors.green3,
      style: TextStyle(
        color: Colors.grey.shade800,
        fontFamily: "nunito",
        fontWeight: FontWeight.bold,
        fontSize: 13.0,
      ),
    );
  }
}
