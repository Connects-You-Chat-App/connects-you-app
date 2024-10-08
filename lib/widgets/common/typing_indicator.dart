import 'package:flutter/material.dart';

class DotWidget extends StatelessWidget {
  const DotWidget({
    required this.color,
    required this.radius,
    super.key,
  });
  final Color? color;
  final double? radius;

  @override
  Widget build(final BuildContext context) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      height: radius,
      width: radius,
    );
  }
}

/// Jumping Dot.
///
/// [numberOfDots] number of dots,
/// [color] color of dots.
/// [radius] radius of dots.
/// [animationDuration] animation duration in milliseconds
/// [innerPadding] Padding between dots
/// [verticalOffset] Defines how much the animation will offset negatively in the `y` axis. Can be either positive or negative, as it'll later be converted into its. negative value. Non-finite or zero (0) values are not accepted.
/// [delay] The delay in milliseconds between animations
class JumpingDots extends StatefulWidget {
  JumpingDots(
      {super.key,
      this.numberOfDots = 3,
      this.radius = 10,
      this.innerPadding = 2.5,
      this.animationDuration = const Duration(milliseconds: 200),
      this.color = const Color(0xfff2c300),
      this.verticalOffset = -20,
      this.delay = 0})
      : assert(verticalOffset.isFinite,
            'Non-finite values cannot be set as an animation offset.'),
        assert(verticalOffset != 0,
            'Zero values (0) cannot be set as an animation offset.');
  final int numberOfDots;
  final Color color;
  final double radius;
  final double innerPadding;
  final Duration animationDuration;
  final double verticalOffset;
  final int delay;

  @override
  _JumpingDotsState createState() => _JumpingDotsState();
}

class _JumpingDotsState extends State<JumpingDots>
    with TickerProviderStateMixin {
  late List<AnimationController>? _animationControllers;

  final List<Animation<double>> _animations = <Animation<double>>[];

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  @override
  void dispose() {
    for (final AnimationController controller in _animationControllers!) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initAnimation() {
    _animationControllers = List<AnimationController>.generate(
      widget.numberOfDots,
      (final int index) {
        return AnimationController(
            vsync: this, duration: widget.animationDuration);
      },
    ).toList();

    for (int i = 0; i < widget.numberOfDots; i++) {
      _animations.add(Tween<double>(
              begin: 0,
              end:
                  -widget.verticalOffset.abs() // Ensure the offset is negative.
              )
          .animate(_animationControllers![i]));
    }

    for (int i = 0; i < widget.numberOfDots; i++) {
      _animationControllers![i]
          .addStatusListener((final AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          _animationControllers![i].reverse();

          if (i != widget.numberOfDots - 1) {
            _animationControllers![i + 1].forward();
          }
        }
        if (i == widget.numberOfDots - 1 &&
            status == AnimationStatus.dismissed) {
          if (widget.delay == 0) {
            _animationControllers![0].forward();
          } else {
            Future<void>.delayed(Duration(milliseconds: widget.delay), () {
              if (mounted) {
                _animationControllers![0].forward();
              }
            });
          }
        }
      });
    }
    _animationControllers!.first.forward();
  }

  @override
  Widget build(final BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              List<Widget>.generate(widget.numberOfDots, (final int index) {
            return AnimatedBuilder(
              animation: _animationControllers![index],
              builder: (final BuildContext context, final Widget? child) {
                return Container(
                  padding: EdgeInsets.all(widget.innerPadding),
                  child: Transform.translate(
                    offset: Offset(0, _animations[index].value),
                    child:
                        DotWidget(color: widget.color, radius: widget.radius),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
