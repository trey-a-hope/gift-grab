import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/data/services/modal_service.dart';
import 'package:gift_grab/domain/providers.dart';
import 'package:gift_grab/presentation/widgets/gg_input_field_widget.dart';
import 'package:gift_grab/presentation/widgets/screen_background_widget.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

class EditProfileScreen extends ConsumerWidget {
  final _controller = TextEditingController();

  EditProfileScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final sessionData = ref.watch(Providers.nakamaSessionDataProvider);

    return ScreenBackgroundWidget(
      child: Center(
        child: sessionData.when(
          data: (data) {
            if (data == null) {
              throw Exception('Data Null');
            }

            _controller.text = data.username;

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
                GGInputFieldWidget(
                  onChanged: (val) {
                    _controller.text = val;
                  },
                  hintText: 'Enter username...',
                ),
                const Gap(20),
                SizedBox(
                  width: Globals.isTablet ? 400 : 200,
                  height: Globals.isTablet ? 100 : 50,
                  child: ElevatedButton(
                    onPressed: _controller.text.isEmpty
                        ? () async => _handleTextEmpty(context)
                        : () async => _attemptSaveUsername(context, ref),
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
    await ref.read(Providers.nakamaSessionDataProvider.notifier).updateUsername(
          newUsername: _controller.text,
        );

    if (!context.mounted) return;

    ModalService.showToast(
      title: 'Username updated...',
      toastificationType: ToastificationType.success,
      icon: const Icon(Icons.check),
      primaryColor: Colors.blue,
    );
  }

  void _handleTextEmpty(BuildContext context) {
    if (!context.mounted) return;

    ModalService.showToast(
      title: 'Username field cannot be empty...',
      toastificationType: ToastificationType.error,
      icon: const Icon(Icons.error),
      primaryColor: Colors.red,
    );
  }
}
