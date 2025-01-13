import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/domain/blocs/account/account_bloc.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/presentation/widgets/stateful_bloc.dart';
import 'package:go_router/go_router.dart';

class MainMenuScreen extends StatefulBloc<AccountBloc, AccountState> {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState
    extends StatefulBlocState<MainMenuScreen, AccountBloc, AccountState> {
  @override
  void initState() {
    super.initState();
    context.read<AccountBloc>().add(FetchAccount());
  }

  @override
  Widget buildLoadedContent(BuildContext context, dynamic state) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Gap(16),
          Text(
            'Welcome Back, ${state.account.user.username ?? 'UNKNOWN'}',
            style: theme.textTheme.displayLarge!
                .copyWith(fontSize: theme.textTheme.bodyLarge!.fontSize! * 2),
          ),
          const Gap(64),
          ElevatedButton(
            child: Text('Play'),
            onPressed: () => context.goNamed(Globals.routes.game),
          ),
          const Gap(16),
          ElevatedButton(
            child: Text('Leaderboard'),
            onPressed: () => context.goNamed(Globals.routes.leaderboard),
          ),
          const Gap(16),
          ElevatedButton(
            child: Text('Groups'),
            onPressed: () => context.goNamed(Globals.routes.groups),
          ),
          const Gap(16),
          ElevatedButton(
            child: Text('Settings'),
            onPressed: () => context.goNamed(Globals.routes.settings),
          ),
          const Gap(50),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GGScaffoldWidget(
      title: 'Gift Grab',
      child: BlocConsumer<AccountBloc, AccountState>(
        builder: builder,
        listener: listener,
      ),
    );
  }
}
