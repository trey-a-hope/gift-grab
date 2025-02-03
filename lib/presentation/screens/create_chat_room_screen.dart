import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/data/services/modal_service.dart';
import 'package:gift_grab/domain/blocs/chat_rooms/chat_rooms_bloc.dart';
import 'package:gift_grab/presentation/extensions/build_context_extensions.dart';
import 'package:gift_grab/presentation/widgets/gg_input_field_widget.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/presentation/widgets/smart_bloc.dart';
import 'package:go_router/go_router.dart';

class CreateChatRoomScreen extends SmartBloc<ChatRoomsBloc, ChatRoomsState> {
  const CreateChatRoomScreen({super.key});

  @override
  Widget buildLoadedContent(BuildContext context, state) {
    state = state as ChatRoomsLoaded;
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GGInputFieldWidget(
            onChanged: (val) {
              context.read<ChatRoomsBloc>().add(ChatRoomNameChange(name: val));
            },
            initialValue: state.newChatRoomName,
            hintText: 'Enter name of chat room...',
          ),
          Spacer(),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                final confirm = await ModalService.showConfirmation(
                  context: context,
                  title: 'Create Chat Room "${state.newChatRoomName}"',
                  message: 'Are you sure?',
                );

                if (confirm == null || confirm == false) {
                  return;
                }

                if (!context.mounted) return;

                context.read<ChatRoomsBloc>().add(
                      SaveChatRoom(
                        name: state.newChatRoomName,
                      ),
                    );
              },
              child: Text('Submit'),
            ),
          )
        ],
      ),
    );
  }

  @override
  void listener(BuildContext context, ChatRoomsState state) {
    super.listener(context, state);

    if (state is ChatRoomsSuccess) {
      context.pop(true);
      context.read<ChatRoomsBloc>().add(FetchChatRooms());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GGScaffoldWidget(
      title: 'Create Chat Room',
      child: BlocConsumer<ChatRoomsBloc, ChatRoomsState>(
        listenWhen: (previous, current) => context.listenWhen(
          Globals.routes.createChatRoom,
        ),
        builder: builder,
        listener: listener,
      ),
    );
  }
}
