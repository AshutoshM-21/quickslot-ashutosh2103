import 'package:flutter/material.dart';
import 'package:quickslot_app/core/theme/app_colors.dart';

class CachedDataBanner extends StatelessWidget {
  const CachedDataBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialBanner(
      backgroundColor: AppColors.borderLight,
      content: const Text('Showing cached data'),
      leading: const Icon(Icons.cloud_off_outlined),
      actions: const [SizedBox.shrink()],
    );
  }
}
