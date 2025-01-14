import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/data/constants/menu_button.dart';
import 'package:gift_grab/domain/blocs/account/account_bloc.dart';
import 'package:gift_grab/presentation/widgets/flex_gridview.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/presentation/widgets/menu_button_widget.dart';
import 'package:gift_grab/presentation/widgets/stateless_bloc.dart';

class MainMenuScreen extends StatelessBloc<AccountBloc, AccountState> {
  const MainMenuScreen({super.key});

  static const buttons = [
    MenuButton.play,
    MenuButton.leaderboard,
    MenuButton.groups,
    MenuButton.settings,
  ];

  @override
  Widget buildLoadedContent(BuildContext context, dynamic state) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Gap(16),
            Text(
              'Welcome Back, ${state.account.user.username ?? 'UNKNOWN'}',
              style: theme.textTheme.displayLarge!
                  .copyWith(fontSize: theme.textTheme.bodyLarge!.fontSize! * 2),
            ),
            const Gap(16),
            Expanded(
              child: FlexGridviewWidget(
                children: buttons
                    .map(
                      (e) => MenuButtonWidget(menuButton: e),
                    )
                    .toList(),
              ),
            )
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
      child: BlocBuilder<AccountBloc, AccountState>(
        builder: builder,
      ),
    );
  }
}
