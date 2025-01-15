import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/domain/blocs/group/user_groups/user_groups_bloc.dart';
import 'package:gift_grab/presentation/widgets/group_details_widget.dart';
import 'package:gift_grab/presentation/widgets/no_results_widget.dart';
import 'package:gift_grab/presentation/widgets/smart_bloc.dart';

class PaginatedUserGroups extends SmartBloc<UserGroupsBloc, UserGroupsState> {
  const PaginatedUserGroups({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<UserGroupsBloc>().add(FetchGroups());
    return BlocConsumer<UserGroupsBloc, UserGroupsState>(
      listener: (context, state) {},
      builder: builder,
    );
  }

  @override
  Widget buildLoadedContent(BuildContext context, state) {
    return state.groups.isEmpty
        ? NoResultsWidget(NoResultsEnum.groups)
        : Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.groups.length,
                  itemBuilder: (BuildContext context, int index) =>
                      GroupDetailsWidget(
                    group: state.groups[index],
                    isOwner: false,
                  ),
                ),
              ),
              if (state.hasMore) ...[
                ElevatedButton(
                  onPressed: () => context
                      .read<UserGroupsBloc>()
                      .add(FetchMoreGroups(groups: state.groups)),
                  child: Text('Fetch More'),
                ),
              ]
            ],
          );
  }
}
