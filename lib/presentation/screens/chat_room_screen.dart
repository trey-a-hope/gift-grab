import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/domain/blocs/chat_rooms/chat_rooms_bloc.dart';
import 'package:gift_grab/presentation/extensions/build_context_extensions.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/presentation/widgets/smart_bloc.dart';

// TODO: Create ChatRoomBloc that will list all messages for this room.
class ChatRoomScreen extends SmartBloc<ChatRoomsBloc, ChatRoomsState> {
  final String room;

  const ChatRoomScreen({
    required this.room,
    super.key,
  });

  @override
  Widget buildLoadedContent(BuildContext context, dynamic state) {
    final theme = Theme.of(context);

    state = state as ChatRoomsLoaded;

    final messages = [];

    return Center(
      child: Text(
        room,
        style: theme.textTheme.headlineLarge,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GGScaffoldWidget(
      title: room,
      child: SafeArea(
        child: Center(
          child: BlocConsumer<ChatRoomsBloc, ChatRoomsState>(
            listenWhen: (previous, current) => context.listenWhen(
              Globals.routes.createChatRoom,
            ),
            listener: listener,
            builder: builder,
          ),
        ),
      ),
    );
  }
}
