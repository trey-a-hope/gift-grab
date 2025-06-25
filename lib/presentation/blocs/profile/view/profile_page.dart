import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/data/services/modal_service.dart';
import 'package:gift_grab/presentation/blocs/account/bloc/account_bloc.dart';
import 'package:gift_grab/presentation/blocs/friends/friends.dart';
import 'package:gift_grab/presentation/widgets/friendship_state_button.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:nakama/nakama.dart';
import '../profile.dart';

class ProfilePage extends StatelessWidget {
  final String uid;

  const ProfilePage(
    this.uid, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (_) => ProfileBloc(
        uid,
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
                    context,
                    title: 'Block ${user?.username ?? ''}',
                    message: 'Are you sure?',
                  );

                  if (confirm == null || confirm == false) return;

                  profileBloc.add(BlockFriend());
                },
                icon: const Icon(Icons.block),
              ),
            ],
            if (state.friendshipState == FriendshipState.blocked) ...[
              IconButton.filledTonal(
                onPressed: () async {
                  final confirm = await ModalService.showConfirmation(
                    context,
                    title: 'Unblock ${user?.username ?? ''}',
                    message: 'Are you sure?',
                  );

                  if (confirm == null || confirm == false) return;

                  profileBloc.add(UnblockFriend());
                },
                icon: const Icon(Icons.lock_open),
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
                        FriendshipStateButton(
                          isMyProfile: state.isMyProfile,
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
}
