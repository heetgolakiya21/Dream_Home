import 'package:dream_home/global/ui_helper.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final GestureTapCallback? onTap;

  const CustomElevatedButton({
    super.key,
    this.text,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 15.0,
              offset: const Offset(5.0, 5.0),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text!,
              style: TextStyle(
                color: MyColors.black0,
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
                fontFamily: "nunito",
              ),
            ),
            Icon(
              icon,
              size: 17.0,
            ),
          ],
        ),
      ),
    );
  }
}
