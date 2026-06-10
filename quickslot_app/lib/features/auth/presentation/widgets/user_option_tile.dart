import 'package:flutter/material.dart';
import 'package:quickslot_app/core/theme/app_colors.dart';
import 'package:quickslot_app/core/widgets/app_card.dart';
import 'package:quickslot_app/features/auth/domain/entities/user.dart';

class UserOptionTile extends StatelessWidget {
  const UserOptionTile({
    super.key,
    required this.user,
    required this.isSelected,
    required this.onTap,
  });

  final User user;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      isSelected: isSelected,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor:
                isSelected ? AppColors.primary : AppColors.primaryLight,
            foregroundColor:
                isSelected ? AppColors.white : AppColors.primary,
            child: Text(
              user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  'User ID: ${user.id}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Radio<int>(
            value: user.id,
            groupValue: isSelected ? user.id : null,
            onChanged: (_) => onTap(),
          ),
        ],
      ),
    );
  }
}
