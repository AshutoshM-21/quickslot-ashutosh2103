import 'package:flutter/material.dart';
import 'package:quickslot_app/core/constants/venue_images.dart';
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
    final imageUrl = VenueImages.resolveForVenue(venue);

    return ClipRRect(
      borderRadius: radius,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              gaplessPlayback: true,
              filterQuality: FilterQuality.medium,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return _GradientBackdrop(style: style);
              },
              errorBuilder: (context, error, stackTrace) {
                return _GradientBackdrop(style: style);
              },
            ),
            Positioned(
              right: -24,
              bottom: -24,
              child: Icon(
                style.icon,
                size: height * 0.75,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.05),
                    Colors.black.withValues(alpha: 0.5),
                  ],
                  stops: const [0.45, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GradientBackdrop extends StatelessWidget {
  const _GradientBackdrop({required this.style});

  final SportStyle style;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: style.gradient,
        ),
      ),
    );
  }
}
