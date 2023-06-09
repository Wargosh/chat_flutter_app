import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function() onPress;
  final bool isLoading;
  final Color backgroundColor;
  final Color textColor;
  final double radius;
  final double height;
  final double textSize;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPress,
    this.isLoading = false,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.radius = 10,
    this.height = 55,
    this.textSize = 17,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: MaterialButton(
        onPressed: onPress,
        child: Center(
          child: !isLoading
              ? Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: textSize,
                  ),
                )
              : const CircularProgressIndicator(color: Colors.white),
        ),
      ),
    );
  }
}
