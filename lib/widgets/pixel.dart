import 'package:flutter/material.dart';

class Pixel extends StatelessWidget {
  final Color? color;
  final Widget? child;

  const Pixel({Key? key, this.color, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        child: Container(
          color: color ?? const Color(0xffcdc1b4),
          child: Center(child: child),
        ),
      ),
    );
  }
}
