import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/data/constants/menu_button.dart';
import 'package:gift_grab/data/services/modal_service.dart';
import 'package:gift_grab/presentation/blocs/account/account.dart';
import 'package:gift_grab/presentation/blocs/auth/bloc/auth_bloc.dart';
import 'package:gift_grab/presentation/widgets/flex_gridview_widget.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/presentation/widgets/menu_button_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
              onPressed: () => showLicensePage(context: context),
              icon: Icon(MdiIcons.fileDocument),
            ),
            IconButton.filledTonal(
              onPressed: () async {
                final confirm = await ModalService.showConfirmation(
                  context,
                  title: 'Logout?',
                  message: 'Are you sure?',
                );

                if (confirm != true) {
                  return;
                }

                if (!context.mounted) return;

                context.read<AuthBloc>().add(Logout());
              },
              icon: Icon(Icons.logout),
            )
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
                              MenuButtonWidget(
                                menuButton: MenuButton.linkedAccounts,
                                onTap: () => context.pushNamed(
                                  Globals.routes.linkedAccounts,
                                ),
                              ),
                              if (state.account != null &&
                                  state.account!.email != null) ...[
                                MenuButtonWidget(
                                  menuButton: MenuButton.deleteAccount,
                                  onTap: () async {
                                    final confirm = await ModalService
                                        .showInputMatchConfirmation(
                                      context: context,
                                      title: 'Delete Account?',
                                      hintText: 'Enter your email to confirm.',
                                      match: state.account!.email!,
                                    );

                                    if (confirm == null || confirm == false) {
                                      return;
                                    }

                                    if (!context.mounted) return;

                                    context
                                        .read<AccountBloc>()
                                        .add(DeleteAccount());
                                  },
                                ),
                              ]
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
