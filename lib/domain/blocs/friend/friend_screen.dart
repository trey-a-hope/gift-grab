 import 'package:flutter/material.dart';
 import 'package:smart_bloc/smart_bloc.dart';

 class FriendScreen extends SmartBloc<FriendBloc, FriendState> {
  const FriendScreen({
    super.key,
  });

  @override
  Widget buildLoadedContent(BuildContext context, dynamic state) {
    state = state as FriendLoaded;
    throw UnimplementedError();
  }

  @override
  void listener(BuildContext context, FriendState state) {
    super.listener(context, state);
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {
    return GGScaffoldWidget(
      title: 'Friends',
      child: Center(
        child: BlocConsumer<FriendBloc, FriendState>(
          listener: listener,
          builder: builder,
        ),
      ),
    );
  }
}