import 'package:flutter/material.dart';

class GlowIcon extends StatelessWidget {
  final Widget child;
  final Color glowColor;
  final double blurRadius;
  final double size;

  const GlowIcon({
    Key? key,
    required this.child,
    required this.glowColor,
    this.blurRadius = 40,
    this.size = 60,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Glow
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: glowColor.withOpacity(0.6),
                blurRadius: blurRadius,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
        child,
      ],
    );
  }
}