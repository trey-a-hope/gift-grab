import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/domain/providers.dart';
import 'package:gift_grab/presentation/widgets/gg_button_widget.dart';
import 'package:gift_grab/presentation/widgets/gg_input_field_widget.dart';
import 'package:gift_grab/presentation/widgets/screen_background_widget.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:go_router/go_router.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  String? _name;
  String? _description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ScreenBackgroundWidget(
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

            ///TODO: Added int slider for number of users allowed.
            ///TODO: Add open/closed checkbox for inviting people to room.
            const Gap(20),
            GGButtonWidget(
              title: 'Submit',
              onPressed: () async => await ref
                  .read(Providers.nakamaGroupsProvider.notifier)
                  .createGroup(
                    name: _name ?? '???',
                    description: _description ?? 'XXX',
                  ),
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
