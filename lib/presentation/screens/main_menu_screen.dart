import 'package:flutter/material.dart';
import 'package:flutter_app_info/flutter_app_info.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/data/constants/menu_button.dart';
import 'package:gift_grab/data/services/modal_service.dart';
import 'package:gift_grab/data/services/web_socket_service.dart';
import 'package:gift_grab/domain/blocs/account/account_bloc.dart';
import 'package:gift_grab/presentation/widgets/flex_gridview.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/presentation/widgets/menu_button_widget.dart';
import 'package:smart_bloc/smart_bloc.dart';
import 'package:go_router/go_router.dart';

class MainMenuScreen extends SmartBloc<AccountBloc, AccountState> {
  final _storage = const FlutterSecureStorage();

  const MainMenuScreen({super.key});

  @override
  Widget buildLoadedContent(BuildContext context, dynamic state) {
    state = state as AccountLoaded;

    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome Back, ${state.account?.user.username ?? 'UNKNOWN'}',
              style: theme.textTheme.displayLarge!
                  .copyWith(fontSize: theme.textTheme.bodyLarge!.fontSize! * 2),
            ),
            const Gap(16),
            Expanded(
              child: FlexGridviewWidget(
                children: [
                  MenuButtonWidget(
                    menuButton: MenuButton.play,
                    onTap: () => context.pushNamed(
                      Globals.routes.game,
                    ),
                  ),
                  MenuButtonWidget(
                    menuButton: MenuButton.profile,
                    onTap: () => context.pushNamed(
                      Globals.routes.profile,
                      pathParameters: {
                        'uid': state.account.user.id,
                      },
                    ),
                  ),
                  MenuButtonWidget(
                    menuButton: MenuButton.friends,
                    onTap: () => context.pushNamed(
                      Globals.routes.friends,
                    ),
                  ),
                  MenuButtonWidget(
                    menuButton: MenuButton.groups,
                    onTap: () => context.pushNamed(
                      Globals.routes.groups,
                    ),
                  ),
                  MenuButtonWidget(
                    menuButton: MenuButton.leaderboard,
                    onTap: () => context.pushNamed(
                      Globals.routes.leaderboard,
                    ),
                  ),
                  MenuButtonWidget(
                    menuButton: MenuButton.liveChat,
                    onTap: () => context.pushNamed(
                      Globals.routes.chatRooms,
                    ),
                  ),
                  MenuButtonWidget(
                    menuButton: MenuButton.tournaments,
                    onTap: () => context.pushNamed(
                      Globals.routes.tournaments,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.read<AccountBloc>().add(FetchAccount());

    return GGScaffoldWidget(
      title: 'Gift Grab',
      actions: [
        IconButton.filledTonal(
          onPressed: () => context.pushNamed(
            Globals.routes.notifications,
          ),
          icon: Icon(Icons.notifications),
        ),
        IconButton.filledTonal(
          onPressed: () => context.pushNamed(
            Globals.routes.searchUsers,
          ),
          icon: Icon(Icons.search),
        ),
        IconButton.filledTonal(
          onPressed: () => context.pushNamed(
            Globals.routes.settings,
          ),
          icon: Icon(Icons.settings),
        ),
      ],
      canPop: false,
      child: BlocConsumer<AccountBloc, AccountState>(
        listener: (context, state) {
          if (state is AccountLoaded) {
            final appInfo = AppInfo.of(context);
            if (!appInfo.target.isTablet) {
              ModalService.showError(
                title: 'Device not best suited for this game.',
              );
            }

            _storage.read(key: 'token').then(
              (token) {
                if (token != null) {
                  WebSocketService().initialize(token);
                }
              },
            );
          }
        },
        builder: builder,
      ),
    );
  }
}
