import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/data/services/modal_service.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:gift_grab/domain/blocs/chat_rooms/chat_rooms_bloc.dart';
import 'package:gift_grab/domain/blocs/leaderboard/leaderboard_bloc.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/presentation/widgets/no_results_widget.dart';
import 'package:gift_grab/presentation/widgets/smart_bloc.dart';
import 'package:go_router/go_router.dart';

class ChatRoomsScreen extends SmartBloc<ChatRoomsBloc, ChatRoomsState> {
  const ChatRoomsScreen({
    super.key,
  });

  @override
  Widget buildLoadedContent(BuildContext context, dynamic state) {
    final theme = Theme.of(context);

    state = state as ChatRoomsLoaded;

    final chatRooms = state.chatRooms;

    return chatRooms.isEmpty
        ? NoResultsWidget(NoResultsEnum.chatRooms)
        : ListView.builder(
            itemCount: chatRooms.length,
            itemBuilder: (c, i) => ListTile(
              title: Text(
                chatRooms[i],
                style: theme.textTheme.displayLarge,
              ),
              trailing: IconButton(
                onPressed: () {},
                icon: IconButton.filledTonal(
                  onPressed: () {
                    ModalService.showSuccess(
                      title: 'TODO: Open ${chatRooms[i]}',
                    );
                  },
                  icon: Icon(
                    Icons.chevron_right,
                  ),
                ),
              ),
            ),
          );
  }

  @override
  void listener(BuildContext context, ChatRoomsState state) {
    super.listener(context, state);

    if (state is LeaderboardSuccess) {
      context.read<LeaderboardBloc>().add(
            FetchLeaderboard(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatRoomsBloc(
        authBloc: context.read<AuthBloc>(),
      )..add(FetchChatRooms()),
      child: GGScaffoldWidget(
        title: 'Chat Rooms',
        actions: [
          IconButton.filledTonal(
            onPressed: () => context.pushNamed(
              Globals.routes.createChatRoom,
            ),
            icon: Icon(Icons.add),
          ),
        ],
        child: SafeArea(
          child: Center(
            child: BlocConsumer<ChatRoomsBloc, ChatRoomsState>(
              listener: listener,
              builder: builder,
            ),
          ),
        ),
      ),
    );
  }
}
