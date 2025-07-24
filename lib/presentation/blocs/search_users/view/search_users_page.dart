import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/domain/services/session_service.dart';
import 'package:gift_grab/presentation/widgets/no_results/no_results_widget.dart';
import 'package:gift_grab/presentation/widgets/user_list_tile.dart';
import 'package:gift_grab_ui/widgets/gg_scaffold_widget.dart';

import '../search_users.dart';

class SearchUsersPage extends StatelessWidget {
  const SearchUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchUsersBloc(
        context.read<SessionService>(),
      ),
      child: const SearchUsersView(),
    );
  }
}

class SearchUsersView extends StatelessWidget {
  const SearchUsersView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = TextEditingController();
    final bloc = context.read<SearchUsersBloc>();

    return GGScaffoldWidget(
      title: 'Search Users',
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AnimatedSearchBar(
              autoFocus: true,
              controller: controller,
              label: "Enter username...",
              labelStyle: theme.textTheme.displaySmall!,
              searchStyle: theme.textTheme.displaySmall!,
              onFieldSubmitted: (query) => bloc.add(SearchUser(query)),
              onChanged: (query) {
                controller.text = query;
                if (query.isEmpty) bloc.add(const ClearSearch());
              },
              onClose: () => bloc.add(const ClearSearch()),
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchUsersBloc, SearchUsersState>(
              builder: (context, state) {
                final user = state.users.isEmpty ? null : state.users.first;

                return state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : state.query.isEmpty
                        ? const SizedBox()
                        : user == null
                            ? const NoResultsWidget(NoResultsEnum.users)
                            : UserListTile(user);
              },
            ),
          )
        ],
      ),
    );
  }
}
