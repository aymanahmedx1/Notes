import 'package:flutter/material.dart';

snackBar(String text) => SnackBar(
  backgroundColor: Colors.white,
  content: Text(
    text,
    style: const TextStyle(color: Colors.deepOrange),
  ),
);