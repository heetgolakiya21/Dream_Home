import 'package:dream_home/global/ui_helper.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton2 extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? text;

  const CustomElevatedButton2({
    super.key,
    this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: const MaterialStatePropertyAll(
          ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
        ),
        backgroundColor: MaterialStatePropertyAll(MyColors.green2),
        padding: const MaterialStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 30.0, vertical: 13.0),
        ),
      ),
      child: Text(
        text!,
        style: TextStyle(
          fontSize: 15.0,
          fontFamily: "nunito",
          fontWeight: FontWeight.bold,
          color: MyColors.white0,
        ),
      ),
    );
  }
}
