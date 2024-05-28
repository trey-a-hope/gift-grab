import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/domain/providers.dart';
import 'package:gift_grab/presentation/widgets/gg_button_widget.dart';
import 'package:gift_grab/presentation/widgets/gg_input_field_widget.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:go_router/go_router.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
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

    return GGScaffoldWidget(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            const Gap(20),
            GGButtonWidget(
              title: 'Submit',
              onPressed: () async {
                await ref
                    .read(Providers.nakamaGroupsProvider.notifier)
                    .createGroup(
                      name: _name ?? '???',
                      description: _description ?? 'XXX',
                      maxCount: _groupCount,
                      open: _isOpen,
                    );

                if (!context.mounted) return;

                context.pop();
              },
            ),
            const Gap(20),
            GGButtonWidget(
              title: 'Back',
              onPressed: () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }
}
