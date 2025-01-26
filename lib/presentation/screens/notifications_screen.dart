import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/domain/blocs/notifications/notifications_bloc.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/presentation/widgets/no_results_widget.dart';
import 'package:gift_grab/presentation/widgets/notification_widget.dart';
import 'package:gift_grab/presentation/widgets/smart_bloc.dart';
import 'package:nakama/src/models/notification.dart' as n;

class NotificationsScreen
    extends SmartBloc<NotificationsBloc, NotificationsState> {
  const NotificationsScreen({
    super.key,
  });

  @override
  void listener(BuildContext context, NotificationsState state) {
    super.listener(context, state);

    if (state is NotificationsSuccess) {
      context.read<NotificationsBloc>().add(
            FetchNotifications(),
          );
    }
  }

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
                itemBuilder: (c, i) {
                  final notification = state.notifications[i] as n.Notification;
                  return NotificationWidget(
                    notification,
                    delete: () => context.read<NotificationsBloc>().add(
                          DeleteNotification(
                            id: notification.id,
                          ),
                        ),
                  );
                },
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GGScaffoldWidget(
      title: 'Notifications',
      child: BlocConsumer<NotificationsBloc, NotificationsState>(
        listener: listener,
        builder: builder,
      ),
    );
  }
}
