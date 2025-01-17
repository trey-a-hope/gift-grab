import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/data/services/modal_service.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:gift_grab/domain/blocs/profile/profile_bloc.dart';
import 'package:gift_grab/presentation/models/leaderboard_entry.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/presentation/widgets/leaderboard_record_widget.dart';
import 'package:gift_grab/presentation/widgets/smart_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends SmartBloc<ProfileBloc, ProfileState> {
  final String uid;
  final String prevRoute;

  const ProfileScreen({
    required this.uid,
    required this.prevRoute,
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
            Text(state.isMyProfile
                ? 'This is my profile'
                : 'Someone elses profile...'),
            CircleAvatar(
              radius: 100,
              backgroundImage: Image.network(
                state.user.avatarUrl?.isEmpty ?? true
                    ? Globals.emptyProfile
                    : state.user.avatarUrl!,
              ).image,
            ),
            Gap(16),
            Text(
              state.user.username ?? 'Unknown Name',
              style: theme.textTheme.headlineLarge,
            ),
            Gap(16),
            if (state.record != null) ...[
              Row(
                children: [
                  Expanded(
                    child: LeaderboardRecordWidget(
                      entry: LeaderboardEntry(
                        record: state.record!,
                        user: state.user,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final confirm = await ModalService.showConfirmation(
                        context: context,
                        title: 'Delete Weekly Record',
                        message: 'Are you sure?',
                      );

                      if (confirm == null || confirm == false) {
                        return;
                      }

                      if (!context.mounted) return;

                      context.read<ProfileBloc>().add(DeleteRecord());
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  )
                ],
              )
            ] else ...[
              Text(
                'No Record for This Week...',
                style: theme.textTheme.headlineLarge,
              )
            ]
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GGScaffoldWidget(
      title: 'Profile',
      goBack: () => context.goNamed(prevRoute),
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
