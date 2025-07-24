import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/domain/services/session_service.dart';
import 'package:gift_grab/presentation/blocs/account/bloc/account_bloc.dart';
import 'package:gift_grab_ui/widgets/gg_scaffold_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:nakama/nakama.dart';

import '../profile.dart';

class ProfilePage extends StatelessWidget {
  final String uid;
  const ProfilePage(this.uid, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc(
        uid,
        context.read<SessionService>(),
        getNakamaClient(),
        context.read<AccountBloc>(),
      )..add(const ReadProfile()),
      child: const ProfileView(),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {},
      builder: (context, state) {
        final user = state.user;

        return GGScaffoldWidget(
          title: user?.username ?? '',
          actions: [
            if (state.isMyProfile) ...[
              IconButton.filledTonal(
                onPressed: () async {
                  final success = await context.pushNamed<bool>(
                    Globals.routes.editProfile,
                    pathParameters: {'uid': user!.id},
                  );

                  if (!context.mounted) return;

                  if (success == true)
                    context.read<ProfileBloc>().add(const ReadProfile());
                },
                icon: const Icon(Icons.edit),
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
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
