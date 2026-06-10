import 'package:flutter/material.dart';
import 'package:quickslot_app/features/venues/domain/entities/venue.dart';

class SportVisuals {
  SportVisuals._();

  static SportStyle forVenue(Venue venue) {
    return forSport(venue.primarySport);
  }

  static SportStyle forSport(String sport) {
    return SportStyle(
      sport: sport,
      icon: _iconForSport(sport),
      gradient: _gradientForSport(sport),
      accent: _accentForSport(sport),
    );
  }

  static IconData _iconForSport(String sport) {
    switch (sport.toLowerCase()) {
      case 'badminton':
        return Icons.sports_tennis_rounded;
      case 'football':
        return Icons.sports_soccer_rounded;
      case 'cricket':
        return Icons.sports_cricket_rounded;
      case 'tennis':
      case 'table tennis':
        return Icons.sports_tennis_rounded;
      case 'basketball':
        return Icons.sports_basketball_rounded;
      case 'swimming':
        return Icons.pool_rounded;
      default:
        return Icons.sports_rounded;
    }
  }

  static List<Color> _gradientForSport(String sport) {
    switch (sport.toLowerCase()) {
      case 'badminton':
        return const [Color(0xFF2A4A52), Color(0xFF1A2B33)];
      case 'football':
        return const [Color(0xFF2D4A3E), Color(0xFF1A2B28)];
      case 'cricket':
        return const [Color(0xFF2A3D5C), Color(0xFF1A2538)];
      case 'tennis':
      case 'table tennis':
        return const [Color(0xFF2A4A45), Color(0xFF1A2B28)];
      case 'basketball':
        return const [Color(0xFF4A3528), Color(0xFF2B1F18)];
      case 'swimming':
        return const [Color(0xFF1E3A5F), Color(0xFF152A45)];
      default:
        return const [Color(0xFF2A4A52), Color(0xFF1A2B33)];
    }
  }

  static Color _accentForSport(String sport) {
    switch (sport.toLowerCase()) {
      case 'cricket':
        return const Color(0xFF60A5FA);
      case 'football':
        return const Color(0xFF34D399);
      case 'basketball':
        return const Color(0xFFFDBA74);
      case 'swimming':
        return const Color(0xFF67C4E2);
      default:
        return const Color(0xFF6EE7B7);
    }
  }
}

class SportStyle {
  const SportStyle({
    required this.sport,
    required this.icon,
    required this.gradient,
    required this.accent,
  });

  final String sport;
  final IconData icon;
  final List<Color> gradient;
  final Color accent;
}
