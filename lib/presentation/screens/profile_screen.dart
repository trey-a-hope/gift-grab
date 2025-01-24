import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:gift_grab/domain/blocs/profile/profile_bloc.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/presentation/widgets/online_label.dart';
import 'package:gift_grab/presentation/widgets/smart_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProfileScreen extends SmartBloc<ProfileBloc, ProfileState> {
  final String uid;

  const ProfileScreen({
    required this.uid,
    super.key,
  });

  @override
  void onAfterMessage(BuildContext context) => context.read<ProfileBloc>().add(
        FetchProfile(),
      );

  @override
  Widget buildLoadedContent(BuildContext context, state) {
    state = state as ProfileLoaded;

    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  state.user.avatarUrl?.isEmpty ?? true
                      ? Globals.emptyProfile
                      : state.user.avatarUrl!,
                ).image,
              ),
            ),
            Gap(16),
            Row(
              children: [
                if (!state.isMyProfile) ...[
                  ElevatedButton(
                    onPressed: () => context.read<ProfileBloc>().add(
                          AddFriend(uid: state.user.id),
                        ),
                    child: Text('Add as Friend'),
                  ),
                ],
                Gap(8),
                OnlineLabel(state.user.online),
              ],
            ),
            Gap(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  state.user.username ?? 'Unknown Name',
                  style: theme.textTheme.displayLarge,
                ),
                Text(
                  'Games Played: ${state.gamesPlayed}',
                  style: theme.textTheme.displayLarge,
                ),
              ],
            ),
            Gap(16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GGScaffoldWidget(
      title: 'Profile',
      child: BlocProvider(
        create: (context) => ProfileBloc(
          uid: uid,
          authBloc: context.read<AuthBloc>(),
        )..add(FetchProfile()),
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: listener,
          builder: builder,
        ),
      ),
    );
  }
}
