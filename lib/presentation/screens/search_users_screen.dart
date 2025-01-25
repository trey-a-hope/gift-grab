import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:gift_grab/domain/blocs/search_users/search_users_bloc.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/presentation/widgets/no_results_widget.dart';
import 'package:gift_grab/presentation/widgets/smart_bloc.dart';
import 'package:gift_grab/presentation/widgets/searched_user_list_tile.dart';
import 'package:go_router/go_router.dart';

class SearchUsersScreen extends SmartBloc<SearchUsersBloc, SearchUsersState> {
  const SearchUsersScreen({
    super.key,
  });

  @override
  Widget buildLoadedContent(BuildContext context, dynamic state) {
    state = state as SearchUsersLoaded;
    final theme = Theme.of(context);

    final controller = TextEditingController(text: state.query);
    final user = state.users.isEmpty ? null : state.users.first;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: AnimatedSearchBar(
            controller: controller,
            label: "Enter username...",
            labelStyle: theme.textTheme.displaySmall!,
            searchStyle: theme.textTheme.displaySmall!,
            onChanged: (value) {
              debugPrint("value on Change");
              context.read<SearchUsersBloc>().add(
                    SearchUser(username: value),
                  );
            },
          ),
        ),
        Expanded(
          child: state.query.isEmpty
              ? SizedBox()
              : user == null
                  ? NoResultsWidget(NoResultsEnum.users)
                  : GestureDetector(
                      onTap: () => context.pushNamed(
                        Globals.routes.profile,
                        pathParameters: {'uid': user.id},
                      ),
                      child: SearchedUserListTile(user),
                    ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GGScaffoldWidget(
      title: 'Search Users',
      child: SafeArea(
        child: Center(
          child: BlocProvider(
            create: (context) => SearchUsersBloc(
              authBloc: context.read<AuthBloc>(),
            ),
            child: BlocConsumer<SearchUsersBloc, SearchUsersState>(
              listener: listener,
              builder: builder,
            ),
          ),
        ),
      ),
    );
  }
}
