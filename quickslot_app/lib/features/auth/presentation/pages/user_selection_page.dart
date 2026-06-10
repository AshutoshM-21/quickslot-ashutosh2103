import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quickslot_app/core/router/app_routes.dart';
import 'package:quickslot_app/core/widgets/app_scaffold.dart';
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
        title: 'Select User',
        body: BlocBuilder<UserSelectionCubit, UserSelectionState>(
          builder: (context, state) {
            return ResponsivePadding(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Who is using QuickSlot?',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choose a profile to continue.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 24),
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
