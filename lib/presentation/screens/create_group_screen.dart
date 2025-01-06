import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/data/services/modal_service.dart';
import 'package:gift_grab/domain/blocs/group/group_bloc.dart';
import 'package:gift_grab/presentation/widgets/gg_button_widget.dart';
import 'package:gift_grab/presentation/widgets/gg_input_field_widget.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:go_router/go_router.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  static const int _minCount = 2;
  static const int _maxCount = 10;

  /// Name of the group.
  String? _name;

  /// Description of the group.
  String? _description;

  /// How many people are allowed in the group.
  int _groupCount = _minCount;

  /// Is the group open to the public.
  bool _isOpen = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<GroupBloc, GroupState>(
      listener: (context, state) {
        if (state is GroupCreatedSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Group created successfully')),
          );
          context.read<GroupBloc>().add(LoadGroupsEvent());
          context.goNamed(Globals.routes.groups);
        }
      },
      child: GGScaffoldWidget(
        child: SafeArea(
          child: ListView(
            children: [
              Text(
                'Create Group',
                style: theme.textTheme.displayLarge!.copyWith(
                  fontSize: Globals.isTablet
                      ? theme.textTheme.displayLarge!.fontSize! * 2
                      : theme.textTheme.displayLarge!.fontSize,
                ),
              ),
              const Gap(20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: GGInputFieldWidget(
                  hintText: 'Enter Group Name',
                  maxLength: 20,
                  onChanged: (val) => setState(
                    () => _name = val,
                  ),
                ),
              ),
              const Gap(20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: GGInputFieldWidget(
                  hintText: 'Description',
                  maxLength: 100,
                  maxLines: 5,
                  onChanged: (val) => setState(
                    () => _description = val,
                  ),
                ),
              ),
              const Gap(20),
              Text(
                'Max Group Count',
                style: theme.textTheme.displaySmall!.copyWith(
                  fontSize: Globals.isTablet
                      ? theme.textTheme.displaySmall!.fontSize! * 2
                      : theme.textTheme.displaySmall!.fontSize,
                ),
              ),
              const Gap(20),
              Slider(
                value: _groupCount.toDouble(),
                min: _minCount.toDouble(),
                max: _maxCount.toDouble(),
                divisions: _maxCount - _minCount,
                label: '$_groupCount',
                onChanged: (groupCount) {
                  setState(
                    () => _groupCount = groupCount.toInt(),
                  );
                },
              ),
              const Gap(20),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Public Group',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    Switch(
                      value: _isOpen,
                      onChanged: (val) => setState(
                        () => _isOpen = val,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(16),
              GGButtonWidget(
                title: 'Submit',
                onPressed: () async => context.read<GroupBloc>().add(
                      CreateGroupEvent(
                        name: _name ?? 'NO NAME GROUP',
                        description: _description ?? 'NO DESCRIPTION GROUP',
                        maxCount: _groupCount,
                        open: _isOpen,
                      ),
                    ),
              ),
              const Gap(16),
              GGButtonWidget(
                title: 'Back',
                onPressed: () => context.goNamed(Globals.routes.groups),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
