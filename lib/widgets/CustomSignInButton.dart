import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.bgcolor,
    required this.txtcolor,
    required this.onPressed, // New prop for the onPressed function
  }) : super(key: key);

  final String icon;
  final String text;
  final Color bgcolor;
  final Color txtcolor;
  final VoidCallback onPressed; // Updated prop for the onPressed function

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 40,
      child: ElevatedButton(
        onPressed: onPressed, // Use the onPressed prop directly
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          backgroundColor: bgcolor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              icon,
              width: 15,
              height: 15,
            ),
            SizedBox(width: 20),
            Flexible(
              child: Text(
                textAlign: TextAlign.center,
                text,
                style: TextStyle(color: txtcolor, fontSize: 12),
                softWrap: true, // Enable wrapping to the next line
              ),
            ),
          ],
        ),
      ),
    );
  }
}
