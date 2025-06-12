import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/data/services/modal_service.dart';
import 'package:gift_grab/presentation/blocs/account/bloc/account_bloc.dart';
import 'package:gift_grab/presentation/blocs/auth/bloc/auth_bloc.dart';
import 'package:gift_grab/presentation/blocs/friends/friends.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nakama/nakama.dart';

import '../profile.dart';

class ProfilePage extends StatelessWidget {
  final String uid;

  const ProfilePage(this.uid, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (_) => ProfileBloc(
        uid,
        context.read<AuthBloc>(),
        context.read<AccountBloc>(),
        context.read<FriendsBloc>(),
      ),
      child: const ProfileView(),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.success != null) {
          ModalService.showSuccess(title: state.success!);
        }
      },
      builder: (context, state) {
        final user = state.user;
        final profileBloc = context.read<ProfileBloc>();

        return GGScaffoldWidget(
          title: user?.username ?? '',
          actions: [
            if (state.isMyProfile) ...[
              IconButton.filledTonal(
                onPressed: () async {
                  final success =
                      await context.pushNamed<bool>(Globals.routes.editProfile);

                  if (!context.mounted) return;

                  if (success != null && success) {
                    profileBloc.add(ReadProfile());
                  }
                },
                icon: const Icon(Icons.edit),
              ),
            ],
            if (state.friendshipState == FriendshipState.mutual) ...[
              IconButton.filledTonal(
                onPressed: () async {
                  final confirm = await ModalService.showConfirmation(
                    context: context,
                    title: 'Block Friend',
                    message: 'Are you sure?',
                  );

                  if (confirm == null || confirm == false) {
                    return;
                  }

                  if (!context.mounted) return;

                  profileBloc.add(BlockFriend());
                },
                icon: const Icon(Icons.block),
              ),
            ],
            if (state.friendshipState == FriendshipState.blocked) ...[
              IconButton.filledTonal(
                onPressed: () async {
                  final confirm = await ModalService.showConfirmation(
                    context: context,
                    title: 'Unblock User',
                    message: 'Are you sure?',
                  );

                  if (confirm == null || confirm == false) {
                    return;
                  }

                  if (!context.mounted) return;

                  profileBloc.add(UnblockFriend());
                },
                icon: Icon(MdiIcons.lockOpen),
              ),
            ]
          ],
          child: Center(
            child: state.isLoading
                ? const CircularProgressIndicator()
                : Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 100,
                          backgroundImage: Image.network(
                            user!.avatarUrl?.isEmpty ?? true
                                ? Globals.emptyProfile
                                : user.avatarUrl!,
                          ).image,
                        ),
                        const Gap(16),
                        _buildFriendshipStateButton(
                          isMyProfile: state.isMyProfile,
                          profileBloc: context.read<ProfileBloc>(),
                          friendshipState: state.friendshipState,
                        ),
                        const Gap(16),
                        Text(
                          'Games Played: ${state.gamesPlayed}',
                          style: theme.textTheme.displayLarge,
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildFriendshipStateButton({
    required bool isMyProfile,
    required ProfileBloc profileBloc,
    required FriendshipState? friendshipState,
  }) {
    switch (friendshipState) {
      case null:
        return isMyProfile
            ? const SizedBox.shrink()
            : ElevatedButton(
                onPressed: () {
                  profileBloc.add(SendRequest());
                },
                child: const Text('Send Request'),
              );
      case FriendshipState.outgoingRequest:
        return ElevatedButton(
          onPressed: () {
            profileBloc.add(CancelOutgoingRequest());
          },
          child: const Text('Cancel Request'),
        );
      case FriendshipState.mutual:
        return ElevatedButton(
          onPressed: () {
            profileBloc.add(DeleteFriend());
          },
          child: const Text('Delete Friend'),
        );
      case FriendshipState.incomingRequest:
        return Row(
          children: [
            ElevatedButton(
              onPressed: () {
                profileBloc.add(AcceptIncomingRequest());
              },
              child: const Text('Accept Request'),
            ),
            const Gap(8),
            ElevatedButton(
              onPressed: () {
                profileBloc.add(RejectIncomingRequest());
              },
              child: const Text('Reject Request'),
            ),
          ],
        );
      case FriendshipState.blocked:
        return SizedBox.shrink();
    }
  }
}
