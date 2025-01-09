import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/domain/blocs/group_my/group_my_bloc.dart';
import 'package:gift_grab/presentation/widgets/group_details_widget.dart';

class GroupMyListView extends StatelessWidget {
  const GroupMyListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupMyBloc, GroupMyState>(
      listener: (context, state) {},
      builder: (context, state) {
        return switch (state) {
          GroupMyLoading() => const Center(child: CircularProgressIndicator()),
          GroupMyLoaded() => Column(
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
                        .read<GroupMyBloc>()
                        .add(FetchMoreGroups(groups: state.groups)),
                    child: Text('Fetch More'),
                  ),
                ]
              ],
            ),
          GroupMyError() => Text('Error'),
          _ => Text('UNKNOWN'),
        };
      },
    );
  }
}
