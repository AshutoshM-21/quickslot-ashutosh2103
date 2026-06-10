import 'package:flutter/material.dart';
import 'package:quickslot_app/features/venues/domain/entities/venue.dart';

class SportVisuals {
  SportVisuals._();

  static SportStyle forVenue(Venue venue) {
    final label = _resolveSportLabel(venue);
    return SportStyle(
      sport: label,
      icon: _iconForSport(label),
      gradient: _gradientForSport(label),
      accent: _accentForSport(label),
    );
  }

  static String _resolveSportLabel(Venue venue) {
    final source = '${venue.name} ${venue.description ?? ''}'.toLowerCase();

    if (source.contains('badminton')) return 'Badminton';
    if (source.contains('football') || source.contains('turf')) {
      return 'Football';
    }
    if (source.contains('cricket')) return 'Cricket';
    if (source.contains('tennis')) return 'Tennis';
    if (source.contains('basketball')) return 'Basketball';
    return 'Sports';
  }

  static IconData _iconForSport(String sport) {
    switch (sport) {
      case 'Badminton':
        return Icons.sports_tennis_rounded;
      case 'Football':
        return Icons.sports_soccer_rounded;
      case 'Cricket':
        return Icons.sports_cricket_rounded;
      case 'Tennis':
        return Icons.sports_tennis_rounded;
      case 'Basketball':
        return Icons.sports_basketball_rounded;
      default:
        return Icons.sports_rounded;
    }
  }

  static List<Color> _gradientForSport(String sport) {
    switch (sport) {
      case 'Badminton':
        return const [Color(0xFF2A4A52), Color(0xFF1A2B33)];
      case 'Football':
        return const [Color(0xFF2D4A3E), Color(0xFF1A2B28)];
      case 'Cricket':
        return const [Color(0xFF2A3D5C), Color(0xFF1A2538)];
      case 'Tennis':
        return const [Color(0xFF2A4A45), Color(0xFF1A2B28)];
      case 'Basketball':
        return const [Color(0xFF4A3528), Color(0xFF2B1F18)];
      default:
        return const [Color(0xFF2A4A52), Color(0xFF1A2B33)];
    }
  }

  static Color _accentForSport(String sport) {
    switch (sport) {
      case 'Cricket':
        return const Color(0xFF60A5FA);
      case 'Football':
        return const Color(0xFF34D399);
      case 'Basketball':
        return const Color(0xFFFDBA74);
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
