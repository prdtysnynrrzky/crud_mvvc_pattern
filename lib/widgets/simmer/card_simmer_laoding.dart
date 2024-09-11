import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CardShimmerLoading extends StatelessWidget {
  final double height;
  final double width;
  const CardShimmerLoading(
      {super.key, this.height = 80, this.width = double.infinity});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0x88FFFFFF),
        borderRadius: BorderRadius.circular(15),
      ),
      height: height,
      width: width,
    )
        .animate(
          onPlay: (controller) => controller.repeat(),
        )
        .shimmer(
          color: const Color(0xFFD9D9D9),
          duration: const Duration(seconds: 1),
          curve: Curves.ease,
        );
  }
}
