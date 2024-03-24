import 'package:dream_home/global/ui_helper.dart';
import 'package:flutter/material.dart';

class CustomTextField3 extends StatelessWidget {
  final TextEditingController? controller;
  final GestureTapCallback? onTap;
  final String? labelText;
  final String? hintText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;

  const CustomTextField3({
    super.key,
    this.controller,
    this.onTap,
    this.labelText,
    this.hintText,
    this.keyboardType = TextInputType.none,
    this.suffixIcon = const Icon(
      Icons.keyboard_arrow_down_outlined,
      size: 20.0,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onTap: onTap,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.none,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: TextStyle(
          fontFamily: "nunito",
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade700,
          fontSize: 13.0,
        ),
        hintStyle: TextStyle(
          fontFamily: "nunito",
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade500,
          fontSize: 13.0,
        ),
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.only(top: 10.0, bottom: 0.0),
        floatingLabelStyle: TextStyle(
          fontFamily: "nunito",
          fontWeight: FontWeight.bold,
          color: MyColors.green2,
          fontSize: 17.0,
        ),
      ),
      showCursor: false,
      scrollPhysics: const BouncingScrollPhysics(),
      style: TextStyle(
        color: Colors.grey.shade800,
        fontFamily: "nunito",
        fontWeight: FontWeight.bold,
        fontSize: 13.0,
      ),
    );
  }
}
