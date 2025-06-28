import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/presentation/blocs/profile/bloc/profile_bloc.dart';
import 'package:gift_grab_ui/gift_grab_ui.dart';
import 'package:nakama/nakama.dart';

class FriendshipStateButton extends StatelessWidget {
  final bool isMyProfile;
  final FriendshipState? friendshipState;

  const FriendshipStateButton({
    required this.isMyProfile,
    this.friendshipState,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final profileBloc = context.read<ProfileBloc>();

    switch (friendshipState) {
      case FriendshipState.outgoingRequest:
        return ElevatedButton(
          onPressed: () async {
            final confirm = await ModalUtil.showConfirmation(
              context,
              title: 'Cancel request',
              message: 'Are you sure?',
            );

            if (confirm == null || confirm == false) return;

            profileBloc.add(CancelOutgoingRequest());
          },
          child: const Text('Cancel Request'),
        );
      case FriendshipState.mutual:
        return ElevatedButton(
          onPressed: () async {
            final confirm = await ModalUtil.showConfirmation(
              context,
              title: 'Delete Friend',
              message: 'Are you sure?',
            );

            if (confirm == null || confirm == false) return;

            profileBloc.add(DeleteFriend());
          },
          child: const Text('Delete Friend '),
        );
      case FriendshipState.incomingRequest:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final confirm = await ModalUtil.showConfirmation(
                  context,
                  title: 'Accept request',
                  message: 'Are you sure?',
                );

                if (confirm == null || confirm == false) return;

                profileBloc.add(AcceptIncomingRequest());
              },
              child: const Text('Accept Request'),
            ),
            const Gap(8),
            ElevatedButton(
              onPressed: () async {
                final confirm = await ModalUtil.showConfirmation(
                  context,
                  title: 'Reject request',
                  message: 'Are you sure?',
                );

                if (confirm == null || confirm == false) return;

                profileBloc.add(RejectIncomingRequest());
              },
              child: const Text('Reject Request'),
            ),
          ],
        );
      case FriendshipState.blocked:
        return SizedBox.shrink();
      case null:
        return isMyProfile
            ? const SizedBox.shrink()
            : ElevatedButton(
                onPressed: () {
                  profileBloc.add(SendRequest());
                },
                child: const Text('Send Request'),
              );
    }
  }
}
