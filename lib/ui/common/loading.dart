import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingComponent extends StatelessWidget {

  const LoadingComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: CircularProgressIndicator(),
      )
    );
  }

}