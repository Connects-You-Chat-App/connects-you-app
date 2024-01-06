import 'package:flutter/material.dart';

class SquircleContainer extends StatelessWidget {
  final Widget? child;

  const SquircleContainer({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(999),
          side: const BorderSide(width: 0, color: Colors.transparent),
        ),
      ),
      child: child,
    );
  }
}