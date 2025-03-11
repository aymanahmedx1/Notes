import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final IconData icon;

  final VoidCallback onPressed;
  final Color color;

  const CustomButton(
      {required this.text,
      required this.onPressed,
      required this.icon,
      this.color = Colors.deepOrange});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: color),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.white),
            ),
            const SizedBox(
              width: 10,
            ),
            Icon(
              icon,
              color: Colors.white,
              size: 25,
            )
          ],
        ),
      ),
    );
  }
}
