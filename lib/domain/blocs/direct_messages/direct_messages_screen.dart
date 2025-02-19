import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:gift_grab/domain/blocs/direct_messages/direct_messages_bloc.dart';
import 'package:gift_grab/presentation/widgets/direct_message_list_tile.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:smart_bloc/smart_bloc.dart';

class DirectMessagesScreen
    extends SmartBloc<DirectMessagesBloc, DirectMessagesState> {
  const DirectMessagesScreen({
    super.key,
  });

  @override
  Widget buildLoadedContent(BuildContext context, dynamic state) {
    state = state as DirectMessagesLoaded;
    final ids = state.directMessages;

    // TODO: Convert uids to actual user accounts...
    return ListView.builder(
      itemCount: ids.length,
      itemBuilder: (c, i) => DirectMessageListTile(
        uid: ids[i],
      ),
    );
  }

  @override
  void listener(BuildContext context, DirectMessagesState state) {
    super.listener(context, state);
    debugPrint('State change: $state');
  }

  @override
  Widget build(BuildContext context) {
    return GGScaffoldWidget(
      title: 'Direct Messages',
      child: BlocProvider(
        create: (context) => DirectMessagesBloc(
          authBloc: context.read<AuthBloc>(),
        )..add(FetchDirectMessages()),
        child: BlocConsumer<DirectMessagesBloc, DirectMessagesState>(
          listener: listener,
          builder: builder,
        ),
      ),
    );
  }
}
