import 'package:flutter/material.dart';

class CustomColumnButton extends StatelessWidget {
  final String text;
  final IconData icon ;
  final VoidCallback onPressed;
  const CustomColumnButton({required this.text, required this.onPressed ,required this.icon});


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(color: Colors.deepOrange,borderRadius: BorderRadius.circular(20)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(text , style: const TextStyle(fontSize: 10,fontWeight: FontWeight.bold ,color: Colors.white),),
                Icon(icon,color: Colors.white, size: 20,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
