import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/domain/blocs/group/all_groups/all_groups_bloc.dart';
import 'package:gift_grab/presentation/widgets/group_details_widget.dart';
import 'package:gift_grab/presentation/widgets/no_results_widget.dart';
import 'package:gift_grab/presentation/widgets/smart_bloc.dart';

class PaginatedAllGroups extends SmartBloc<AllGroupsBloc, AllGroupsState> {
  const PaginatedAllGroups({super.key});

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
                      .read<AllGroupsBloc>()
                      .add(FetchMoreGroups(groups: state.groups)),
                  child: Text('Fetch More'),
                ),
              ]
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    context.read<AllGroupsBloc>().add(FetchGroups());
    return BlocBuilder<AllGroupsBloc, AllGroupsState>(
      builder: builder,
    );
  }
}
