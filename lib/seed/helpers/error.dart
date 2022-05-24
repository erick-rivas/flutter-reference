import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorComponent extends StatelessWidget {

  final String message;
  const ErrorComponent({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Error"),
    );
  }

}