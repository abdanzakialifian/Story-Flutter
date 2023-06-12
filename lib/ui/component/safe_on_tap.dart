import 'package:flutter/material.dart';

class SafeOnTap extends StatefulWidget {
  final Widget child;
  final GestureTapCallback? onSafeTap;
  final int intervalMs;

  const SafeOnTap({
    Key? key,
    required this.onSafeTap,
    required this.child,
    this.intervalMs = 500,
  }) : super(key: key);

  @override
  State<SafeOnTap> createState() => _SafeOnTapState();
}

class _SafeOnTapState extends State<SafeOnTap> {
  int lastTimeClicked = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // safe double click gesture
        final now = DateTime.now().millisecondsSinceEpoch;
        if (now - lastTimeClicked < widget.intervalMs) return;
        lastTimeClicked = now;
        widget.onSafeTap?.call();
      },
      child: widget.child,
    );
  }
}
