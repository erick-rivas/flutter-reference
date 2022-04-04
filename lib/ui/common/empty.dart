import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmptyComponent extends StatelessWidget {

  const EmptyComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Center(
          child: Text("No data"),
        ),
      ),
    );
  }

}