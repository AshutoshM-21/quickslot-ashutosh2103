import 'package:flutter/material.dart';
import 'package:quickslot_app/core/theme/sport_visuals.dart';
import 'package:quickslot_app/features/venues/domain/entities/venue.dart';

class VenueHeroImage extends StatelessWidget {
  const VenueHeroImage({
    super.key,
    required this.venue,
    this.height = 200,
    this.borderRadius,
  });

  final Venue venue;
  final double height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final style = SportVisuals.forVenue(venue);
    final radius = borderRadius ?? BorderRadius.circular(20);

    return ClipRRect(
      borderRadius: radius,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: style.gradient,
                ),
              ),
            ),
            Positioned(
              right: -24,
              bottom: -24,
              child: Icon(
                style.icon,
                size: height * 0.75,
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.05),
                    Colors.black.withValues(alpha: 0.55),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
