import 'package:dream_home/global/ui_helper.dart';
import 'package:flutter/material.dart';

class CustomTextField1 extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization? textCapitalization;
  final bool autocorrect;
  final bool autofocus;
  final bool readOnly;
  final ValueChanged<String>? onSubmitted;

  const CustomTextField1({
    required this.icon,
    required this.hintText,
    required this.controller,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.textCapitalization = TextCapitalization.words,
    this.autocorrect = true,
    this.autofocus = false,
    this.readOnly = false,
    this.onSubmitted,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: MyColors.black0,
          width: 0.7,
        ),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Row(
        children: [
          Icon(icon),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            child: Container(
              height: 30.0,
              width: 1.0,
              decoration: BoxDecoration(border: Border.all(width: 0.7)),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: onSubmitted,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              textCapitalization: textCapitalization!,
              autocorrect: autocorrect,
              autofocus: autofocus,
              readOnly: readOnly,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                hintStyle: const TextStyle(
                  fontSize: 16.0,
                  fontFamily: "nunito",
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              keyboardAppearance: Brightness.light,
              cursorColor: MyColors.green2,
              cursorRadius: const Radius.circular(100.0),
              scrollPhysics: const BouncingScrollPhysics(
                decelerationRate: ScrollDecelerationRate.fast,
              ),
              style: TextStyle(
                color: MyColors.black0,
                fontWeight: FontWeight.w700,
                fontSize: 16.0,
                fontFamily: "nunito",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
