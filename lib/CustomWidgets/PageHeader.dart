import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Pageheader extends StatelessWidget {
  final String name ;

  const Pageheader({required this.name});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: const TextStyle(
                color: Colors.grey, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );

  }
}
