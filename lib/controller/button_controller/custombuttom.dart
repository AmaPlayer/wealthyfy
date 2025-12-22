import 'package:flutter/material.dart';
import 'package:meeting/helper/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  final double? height;
  final double? width;
  final Color? color;
  final TextStyle? textStyle;

  const CustomButton({super.key, 
    required this.text,
    required this.onPressed,
    this.height,
    this.width,
    this.color,
    this.textStyle,

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? MediaQuery.of(context).size.width * 10,
      height: height ?? 50.0,
      decoration: BoxDecoration(
        color: color ?? ColorConstants.DarkMahroon,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: textStyle ??
              const TextStyle(color: Colors.white, fontSize: 20),),
      ),
    );
  }
}
