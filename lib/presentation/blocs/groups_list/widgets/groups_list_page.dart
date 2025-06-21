import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/presentation/blocs/groups_list/bloc/groups_list_bloc.dart';
import 'package:gift_grab/presentation/blocs/groups_list/widgets/group_details_list_tile.dart';
import 'package:gift_grab/presentation/widgets/no_results_widget.dart';

class GroupsListPage extends StatelessWidget {
  const GroupsListPage();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupsListBloc, GroupsListState>(
      builder: (context, state) {
        if (state.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        final groups = state.groups;

        return Column(
          children: [
            Expanded(
              child: groups.isEmpty
                  ? NoResultsWidget(NoResultsEnum.allGroups)
                  : ListView.builder(
                      itemCount: groups.length,
                      itemBuilder: (_, int index) => GroupDetailsListTile(
                        group: groups[index],
                        isOwner: false,
                      ),
                    ),
            ),
            if (state.cursor != null) ...[
              ElevatedButton(
                child: const Text('Fetch More Groups'),
                onPressed: () => context
                    .read<GroupsListBloc>()
                    .add(ListGroups(clearCursor: false)),
              )
            ]
          ],
        );
      },
    );
  }
}
