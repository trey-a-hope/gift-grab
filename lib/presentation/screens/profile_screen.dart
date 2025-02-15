import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:gift_grab/domain/blocs/profile/profile_bloc.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/presentation/widgets/leaderboard_records_list_view.dart';
import 'package:gift_grab/presentation/widgets/no_results_widget.dart';
import 'package:gift_grab/presentation/widgets/online_label.dart';
import 'package:smart_bloc/smart_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nakama/nakama.dart';

class ProfileScreen extends SmartBloc<ProfileBloc, ProfileState> {
  final String uid;

  const ProfileScreen({
    required this.uid,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(
        uid: uid,
        authBloc: context.read<AuthBloc>(),
      )..add(FetchProfile()),
      child: Builder(
        builder: (context) {
          return BlocConsumer<ProfileBloc, ProfileState>(
            listener: listener,
            builder: (context, state) {
              bool canEdit = false;
              String? username;

              if (state is ProfileLoaded) {
                canEdit = state.isMyProfile;
                username = state.user.username;
              }

              return GGScaffoldWidget(
                title: username ?? '',
                actions: [
                  if (canEdit) ...[
                    IconButton.filledTonal(
                      onPressed: () async {
                        final success = await context
                            .pushNamed<bool>(Globals.routes.editProfile);

                        if (!context.mounted) return;

                        if (success != null && success) {
                          context.read<ProfileBloc>().add(FetchProfile());
                        }
                      },
                      icon: Icon(Icons.edit),
                    ),
                  ]
                ],
                child: builder(context, state),
              );
            },
          );
        },
      ),
    );
  }

  @override
  void listener(BuildContext context, ProfileState state) {
    super.listener(context, state);

    if (state is ProfileSuccess) {
      context.read<ProfileBloc>().add(
            FetchProfile(),
          );
    }
  }

  Widget _buildFriendButton(
    BuildContext context,
    String uid,
    FriendshipState? friendshipState,
  ) {
    switch (friendshipState) {
      case null:
        return ElevatedButton(
          onPressed: () => context.read<ProfileBloc>().add(
                AddFriend(uid: uid),
              ),
          child: Text('Add as Friend'),
        );
      case FriendshipState.mutual:
        return ElevatedButton(
          onPressed: () => context.read<ProfileBloc>().add(
                DeleteFriend(uid: uid),
              ),
          child: Text('Delete Friend'),
        );
      case FriendshipState.outgoingRequest:
        return ElevatedButton(
          onPressed: () => context.read<ProfileBloc>().add(
                DeleteFriend(uid: uid),
              ),
          child: Text('Cancel Request'),
        );
      case FriendshipState.incomingRequest:
        return ElevatedButton(
          onPressed: () => context.read<ProfileBloc>().add(
                AddFriend(uid: uid),
              ),
          child: Text('Accept Friend Request'),
        );
      case FriendshipState.blocked:
        return SizedBox.shrink();
    }
  }

  @override
  Widget buildLoadedContent(BuildContext context, state) {
    state = state as ProfileLoaded;

    final user = state.user;

    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => state.isMyProfile
                  ? context.read<ProfileBloc>().add(
                        UploadPhoto(),
                      )
                  : null,
              child: CircleAvatar(
                radius: 100,
                backgroundImage: Image.network(
                  user.avatarUrl?.isEmpty ?? true
                      ? Globals.emptyProfile
                      : user.avatarUrl!,
                ).image,
              ),
            ),
            Gap(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!state.isMyProfile) ...[
                  _buildFriendButton(context, user.id, state.friendshipState),
                  Gap(8),
                  ElevatedButton(
                    onPressed: () => context.pushNamed(
                      Globals.routes.chatRoom,
                      pathParameters: {
                        'target': user.id,
                        'title': user.username ?? 'Unknown User Name',
                      },
                      extra: ChannelType.directMessage,
                    ),
                    child: Text('Send Message'),
                  ),
                  Gap(8),
                ],
                OnlineLabel(user.online),
              ],
            ),
            Gap(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Games Played: ${state.gamesPlayed}',
                  style: theme.textTheme.displayLarge,
                ),
              ],
            ),
            Gap(16),
            Expanded(
              child: LeaderboardRecordsListView(
                entries: state.tournamentEntries,
                title: 'Tournament records for Daily Dash',
                noResults: NoResultsEnum.tournament,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
