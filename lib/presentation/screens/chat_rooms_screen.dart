import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/domain/blocs/chat_rooms/chat_rooms_bloc.dart';
import 'package:gift_grab/presentation/extensions/build_context_extensions.dart';
import 'package:gift_grab/presentation/widgets/chat_room_list_tile.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/presentation/widgets/no_results_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:nakama/nakama.dart';
import 'package:smart_bloc/smart_bloc.dart';

class ChatRoomsScreen extends SmartBloc<ChatRoomsBloc, ChatRoomsState> {
  const ChatRoomsScreen({
    super.key,
  });

  @override
  Widget buildLoadedContent(BuildContext context, dynamic state) {
    state = state as ChatRoomsLoaded;

    final rooms = state.rooms;

    return rooms.isEmpty
        ? NoResultsWidget(NoResultsEnum.chatRooms)
        : ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (c, i) => ChatRoomListTile(
              target: rooms[i],
              channelType: ChannelType.room,
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return GGScaffoldWidget(
      title: 'Chat Rooms',
      actions: [
        IconButton.filledTonal(
          onPressed: () => context.pushNamed(
            Globals.routes.createChatRoom,
          ),
          icon: Icon(Icons.add),
        ),
      ],
      child: Center(
        child: BlocConsumer<ChatRoomsBloc, ChatRoomsState>(
          listenWhen: (previous, current) => context.listenWhen(
            Globals.routes.createChatRoom,
          ),
          listener: listener,
          builder: builder,
        ),
      ),
    );
  }
}
