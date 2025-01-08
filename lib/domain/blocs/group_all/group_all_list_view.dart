import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/domain/blocs/group_all/group_all_bloc.dart';
import 'package:gift_grab/domain/blocs/group_all/group_all_event.dart';
import 'package:gift_grab/domain/blocs/group_all/group_all_state.dart';
import 'package:gift_grab/presentation/widgets/group_details_widget.dart';

class GroupAllListView extends StatelessWidget {
  const GroupAllListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupAllBloc, GroupAllState>(
      builder: (context, state) {
        return switch (state) {
          GroupAllLoading() => const Center(child: CircularProgressIndicator()),
          GroupAllLoaded() => Column(
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
                        .read<GroupAllBloc>()
                        .add(FetchMoreGroups(groups: state.groups)),
                    child: Text('Fetch More'),
                  ),
                ]
              ],
            ),
          GroupAllError() => Text('Error'),
          _ => Text('UNKNOWN'),
        };
      },
    );
  }
}
