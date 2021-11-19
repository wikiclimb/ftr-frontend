import 'package:flutter/material.dart';

/// Renders a horizontal widget that displays a rating value as stars.
///
/// Uses the value passed as [rating] to calculate the number of stars
/// to display, it will also display the value as digits [displayRatingDigits]
/// and the total count of ratings [ratingsCount] unless they are hidden setting
/// the [displayRatingsCount] options to false.
class StarRatingWidget extends StatelessWidget {
  const StarRatingWidget({
    Key? key,
    required double rating,
    required ratingsCount,
    displayRatingDigits = true,
    displayRatingsCount = true,
  })  : _rating = rating,
        _ratingsCount = ratingsCount,
        _displayRatingDigits = displayRatingDigits,
        _displayRatingsCount = displayRatingsCount,
        super(key: key);

  final bool _displayRatingDigits;
  final bool _displayRatingsCount;
  final double _rating;
  final int _ratingsCount;

  @override
  Widget build(BuildContext context) {
    final fullStars = _rating.truncate();
    final bool displayHalfStar = _rating - fullStars > 0.5;
    final int emptyStars = 5 - fullStars - (displayHalfStar ? 1 : 0);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Generate as many full starts as the full value of rating.
        ...List.generate(
          fullStars,
          (i) => const Icon(
            Icons.star,
            size: 16,
            color: Colors.purple,
          ),
        ),
        if (displayHalfStar)
          const Icon(
            Icons.star_half,
            size: 16,
            color: Colors.purple,
          ),
        // Generate as many empty stars as needed to reach 5.
        ...List.generate(
          emptyStars,
          (i) => const Icon(
            Icons.star_outline,
            size: 16,
            color: Colors.purple,
          ),
        ),
        if (_displayRatingDigits)
          Text(
            '$_rating',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        const SizedBox(width: 8),
        if (_displayRatingsCount)
          Text(
            '($_ratingsCount)',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
      ],
    );
  }
}
