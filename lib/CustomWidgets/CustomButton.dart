import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final IconData icon ;
  final VoidCallback onPressed;
  const CustomButton({required this.text, required this.onPressed ,required this.icon});


  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5 , horizontal: 0),
          child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(text , style: TextStyle(fontWeight: FontWeight.w600 ,fontSize: 16),),
              const SizedBox(width: 10,),
              Icon(icon)
            ],
          ),
        ),
      ),
    );
  }
}
