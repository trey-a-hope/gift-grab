import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/presentation/blocs/account/bloc/account_bloc.dart';
import 'package:gift_grab/presentation/widgets/flex_gridview_widget.dart';
import 'package:gift_grab/presentation/widgets/menu_button/menu_button_widget.dart';
import 'package:gift_grab_ui/widgets/gg_scaffold_widget.dart';
import 'package:go_router/go_router.dart';

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AccountBloc>()..add(const ReadAccount());
    return const MainMenuView();
  }
}

class MainMenuView extends StatelessWidget {
  const MainMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<AccountBloc, AccountState>(
      builder: (
        context,
        state,
      ) {
        return GGScaffoldWidget(
          title: 'Gift Grab',
          canPop: false,
          actions: [
            IconButton.filledTonal(
              onPressed: () => context.pushNamed(
                Globals.routes.settings,
              ),
              icon: const Icon(Icons.settings),
            ),
          ],
          child: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Text(
                        'Welcome Back, ${state.account!.user.username}',
                        style: theme.textTheme.displayLarge!.copyWith(
                          fontSize: theme.textTheme.headlineLarge!.fontSize!,
                        ),
                      ),
                      Expanded(
                        child: FlexGridviewWidget(
                          children: [
                            MenuButtonWidget(
                              menuButton: MenuButton.play,
                              onTap: () =>
                                  context.pushNamed(Globals.routes.game),
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
        );
      },
    );
  }
}
