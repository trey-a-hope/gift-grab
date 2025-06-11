import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/presentation/blocs/auth/bloc/auth_bloc.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/presentation/widgets/no_results_widget.dart';
import 'package:gift_grab/presentation/widgets/searched_user_list_tile.dart';
import 'package:go_router/go_router.dart';

import '../search_users.dart';

class SearchUsersPage extends StatelessWidget {
  const SearchUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchUsersBloc(context.read<AuthBloc>()),
      child: const SearchUsersView(),
    );
  }
}

class SearchUsersView extends StatelessWidget {
  const SearchUsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchUsersBloc, SearchUsersState>(
      builder: (context, state) {
        final searchUsersBloc = context.read<SearchUsersBloc>();
        final theme = Theme.of(context);

        final controller = TextEditingController(text: state.query);
        final user = state.users.isEmpty ? null : state.users.first;

        return GGScaffoldWidget(
          title: 'Search Users',
          child: Center(
            child: state.isLoading
                ? CircularProgressIndicator()
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: AnimatedSearchBar(
                          autoFocus: true,
                          controller: controller,
                          label: "Enter username...",
                          labelStyle: theme.textTheme.displaySmall!,
                          searchStyle: theme.textTheme.displaySmall!,
                          onChanged: (username) =>
                              searchUsersBloc.add(SearchUser(username)),
                          onClose: () => searchUsersBloc.add(
                            SearchUser(''),
                          ),
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
                  ),
          ),
        );
      },
    );
  }
}
