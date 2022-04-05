import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingComponent extends StatelessWidget {

  final String message;
  const LoadingComponent({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator();
  }

}