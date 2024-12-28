import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/data/services/modal_service.dart';
import 'package:gift_grab/domain/providers.dart';
import 'package:gift_grab/presentation/widgets/gg_input_field_widget.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:go_router/go_router.dart';

class EditProfileScreen extends ConsumerWidget {
  final _controller = TextEditingController();

  EditProfileScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final accountAysnc = ref.watch(Providers.nakamaAccountProvider);

    return GGScaffoldWidget(
      child: Center(
        child: accountAysnc.when(
          data: (account) {
            _controller.text = account.username;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Edit Profile',
                  style: theme.textTheme.displayLarge!.copyWith(
                    fontSize: Globals.isTablet
                        ? theme.textTheme.displayLarge!.fontSize! * 2
                        : theme.textTheme.displayLarge!.fontSize,
                  ),
                ),
                const Gap(50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GGInputFieldWidget(
                    onChanged: (val) {
                      _controller.text = val;
                    },
                    initialValue: _controller.text,
                    hintText: 'Enter username...',
                  ),
                ),
                const Gap(20),
                SizedBox(
                  width: Globals.isTablet ? 400 : 200,
                  height: Globals.isTablet ? 100 : 50,
                  child: ElevatedButton(
                    onPressed: () => _attemptSaveUsername(context, ref),
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontSize: Globals.isTablet ? 50 : 25,
                      ),
                    ),
                  ),
                ),
                const Gap(20),
                SizedBox(
                  width: Globals.isTablet ? 400 : 200,
                  height: Globals.isTablet ? 100 : 50,
                  child: ElevatedButton(
                    onPressed: () => context.pop(),
                    child: Text(
                      'Back',
                      style: TextStyle(
                        fontSize: Globals.isTablet ? 50 : 25,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (err, stack) => Text(
            err.toString(),
          ),
        ),
      ),
    );
  }

  void _attemptSaveUsername(BuildContext context, WidgetRef ref) async {
    try {
      // await ref
      //     .read(Providers.nakamaSessionDataProvider.notifier)
      //     .updateUsername(
      //       newUsername: _controller.text,
      //     );

      // if (!context.mounted) return;

      // ModalService.showSuccess(
      //   title: 'Username has been updated.',
      // );

      // context.pop();
    } catch (e) {
      ModalService.showError(title: e.toString());
    }
  }
}
