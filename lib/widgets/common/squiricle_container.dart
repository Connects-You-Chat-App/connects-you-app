import 'package:flutter/material.dart';

class SquircleContainer extends StatelessWidget {

  const SquircleContainer({super.key, this.child});
  final Widget? child;

  @override
  Widget build(final BuildContext context) {
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