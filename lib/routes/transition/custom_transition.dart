import 'package:flutter/widgets.dart';

class CustomTransition extends PageRouteBuilder {
  CustomTransition({required this.child, this.direction = AxisDirection.up})
      : super(
            transitionDuration: const Duration(seconds: 1),
            reverseTransitionDuration: const Duration(seconds: 3),
            pageBuilder: (context, animation, secondryAnimation) => child);
  Widget child;
  AxisDirection direction;

  @override
  Widget buildTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
        position: Tween<Offset>(begin: getOffset(), end: Offset.zero)
            .animate(animation),
        child: child);
  }

  Offset getOffset() {
    switch (direction) {
      case AxisDirection.up:
        return const Offset(0, 1);
      case AxisDirection.down:
        return const Offset(0, -1);
      case AxisDirection.left:
        return const Offset(1, 0);
      case AxisDirection.right:
        return const Offset(-1, 0);
      default:
        return const Offset(0, 1);
    }
  }
}
