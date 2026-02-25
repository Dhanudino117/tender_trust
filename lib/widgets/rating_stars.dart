import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final Color? color;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 16,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final starColor = color ?? const Color(0xFFFFD166);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        if (i < rating.floor()) {
          return Icon(Icons.star_rounded, size: size, color: starColor);
        } else if (i < rating) {
          return Icon(Icons.star_half_rounded, size: size, color: starColor);
        } else {
          return Icon(
            Icons.star_outline_rounded,
            size: size,
            color: starColor.withValues(alpha: 0.35),
          );
        }
      }),
    );
  }
}

/// Interactive star rating for reviews
class InteractiveRatingStars extends StatelessWidget {
  final int rating;
  final double size;
  final ValueChanged<int> onChanged;

  const InteractiveRatingStars({
    super.key,
    required this.rating,
    required this.onChanged,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        return GestureDetector(
          onTap: () => onChanged(i + 1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              i < rating ? Icons.star_rounded : Icons.star_outline_rounded,
              size: size,
              color: const Color(0xFFFFD166),
            ),
          ),
        );
      }),
    );
  }
}
