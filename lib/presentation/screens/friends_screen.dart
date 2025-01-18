import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:gift_grab/domain/blocs/friends/friends_bloc.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/presentation/widgets/smart_bloc.dart';

class FriendsScreen extends SmartBloc<FriendsBloc, FriendsState> {
  const FriendsScreen({super.key});

  @override
  Widget buildLoadedContent(BuildContext context, dynamic state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Friends go here...'),
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
