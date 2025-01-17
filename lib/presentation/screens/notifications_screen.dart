import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/domain/blocs/notifications/notifications_bloc.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/presentation/widgets/no_results_widget.dart';
import 'package:gift_grab/presentation/widgets/smart_bloc.dart';
import 'package:go_router/go_router.dart';

class NotificationsScreen
    extends SmartBloc<NotificationsBloc, NotificationsState> {
  final BuildContext initialContext;

  NotificationsScreen({
    required this.initialContext,
    super.key,
  }) {
    initialContext.read<NotificationsBloc>().add(
          FetchNotifications(),
        );
  }

  @override
  void onAfterMessage(BuildContext context) =>
      context.read<NotificationsBloc>().add(
            FetchNotifications(),
          );

  @override
  Widget buildLoadedContent(BuildContext context, state) {
    state = state as NotificationsLoaded;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: state.notifications.isEmpty
            ? NoResultsWidget(NoResultsEnum.notifications)
            : ListView.builder(
                itemCount: state.notifications.length,
                itemBuilder: (c, i) => ListTile(
                  title: Text('Notification $i'),
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GGScaffoldWidget(
      title: 'Notifications',
      goBack: () => context.goNamed(Globals.routes.main),
      child: BlocConsumer<NotificationsBloc, NotificationsState>(
        listener: listener,
        builder: builder,
      ),
    );
  }
}
