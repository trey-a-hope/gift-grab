import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/data/constants/menu_button.dart';
import 'package:gift_grab/presentation/blocs/account/account.dart';
import 'package:gift_grab/presentation/widgets/flex_gridview_widget.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/presentation/widgets/menu_button_widget.dart';
import 'package:go_router/go_router.dart';

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AccountBloc>()..add(ReadAccount());
    return const MainMenuView();
  }
}

class MainMenuView extends StatelessWidget {
  const MainMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        final theme = Theme.of(context);

        return GGScaffoldWidget(
          title: 'Gift Grab',
          actions: [
            IconButton.filledTonal(
              onPressed: () => context.pushNamed(
                Globals.routes.settings,
              ),
              icon: Icon(Icons.settings),
            ),
          ],
          canPop: false,
          child: Center(
            child: state.isLoading
                ? CircularProgressIndicator()
                : Padding(
                    padding: EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Welcome Back, ${state.account!.user.username}',
                          style: theme.textTheme.displayLarge!.copyWith(
                            fontSize: theme.textTheme.headlineLarge!.fontSize!,
                          ),
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
                                    'uid': state.account!.user.id,
                                  },
                                ),
                              ),
                              MenuButtonWidget(
                                menuButton: MenuButton.leaderboard,
                                onTap: () => context.pushNamed(
                                  Globals.routes.leaderboard,
                                  pathParameters: {
                                    'uid': state.account!.user.id,
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
                                menuButton: MenuButton.searchUsers,
                                onTap: () => context.pushNamed(
                                  Globals.routes.searchUsers,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
