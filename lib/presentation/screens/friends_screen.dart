import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:gift_grab/domain/blocs/friends/friends_bloc.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/presentation/widgets/smart_bloc.dart';
import 'package:gift_grab/presentation/widgets/user_details_widget.dart';

class FriendsScreen extends SmartBloc<FriendsBloc, FriendsState> {
  const FriendsScreen({super.key});

  @override
  Widget buildLoadedContent(BuildContext context, dynamic state) {
    state = state as FriendsLoaded;

    final friends = state.friends;

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: friends.length,
            itemBuilder: (c, i) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(child: UserDetailsWidget(friends[i].user)),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Block'),
                  ),
                  Gap(8),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Delete'),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (state.cursor != null) ...[
          ElevatedButton(
            child: Text('Fetch More Friends'),
            onPressed: () => context.read<FriendsBloc>().add(
                  FetchMoreFriends(),
                ),
          )
        ]
      ],
    );
  }

  @override
  void onAfterMessage(BuildContext context) => context.read<FriendsBloc>().add(
        FetchFriends(),
      );

  @override
  Widget build(BuildContext context) {
    return GGScaffoldWidget(
      title: 'Friends',
      child: SafeArea(
        child: Center(
          child: BlocProvider(
            create: (context) => FriendsBloc(
              authBloc: context.read<AuthBloc>(),
            )..add(FetchFriends()),
            child: BlocConsumer<FriendsBloc, FriendsState>(
              listener: listener,
              builder: builder,
            ),
          ),
        ),
      ),
    );
  }
}
