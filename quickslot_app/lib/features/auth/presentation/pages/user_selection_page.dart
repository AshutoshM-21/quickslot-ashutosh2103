import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quickslot_app/core/constants/app_constants.dart';
import 'package:quickslot_app/core/router/app_routes.dart';
import 'package:quickslot_app/core/theme/app_colors.dart';
import 'package:quickslot_app/core/widgets/app_scaffold.dart';
import 'package:quickslot_app/core/widgets/app_section_header.dart';
import 'package:quickslot_app/core/widgets/responsive_padding.dart';
import 'package:quickslot_app/features/auth/presentation/cubit/user_selection_cubit.dart';
import 'package:quickslot_app/features/auth/presentation/cubit/user_selection_state.dart';
import 'package:quickslot_app/features/auth/presentation/widgets/user_option_tile.dart';

class UserSelectionPage extends StatelessWidget {
  const UserSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserSelectionCubit, UserSelectionState>(
      listenWhen: (previous, current) =>
          !previous.isCompleted && current.isCompleted,
      listener: (context, state) {
        context.go(AppRoutes.home);
      },
      child: AppScaffold(
        body: BlocBuilder<UserSelectionCubit, UserSelectionState>(
          builder: (context, state) {
            return ResponsivePadding(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  Center(
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: const Icon(
                        Icons.event_available_rounded,
                        size: 36,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppConstants.appName,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 32),
                  const AppSectionHeader(
                    title: 'Who is using QuickSlot?',
                    subtitle: 'Choose a profile to continue booking.',
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.separated(
                      itemCount: state.users.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final user = state.users[index];
                        final isSelected = state.selectedUser?.id == user.id;

                        return UserOptionTile(
                          user: user,
                          isSelected: isSelected,
                          onTap: () {
                            context.read<UserSelectionCubit>().selectUser(user);
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: state.canContinue
                        ? () {
                            context
                                .read<UserSelectionCubit>()
                                .continueWithSelection();
                          }
                        : null,
                    child: const Text('Continue'),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
