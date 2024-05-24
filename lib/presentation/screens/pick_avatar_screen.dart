import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/data/services/modal_service.dart';
import 'package:gift_grab/domain/providers.dart';
import 'package:gift_grab/presentation/widgets/gg_button_widget.dart';
import 'package:gift_grab/presentation/widgets/screen_background_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:toastification/toastification.dart';

class PickAvatarScreen extends ConsumerWidget {
  const PickAvatarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAvatar = ref.watch(Providers.selectedAvatarProvider);

    return ScreenBackgroundWidget(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Gap(50),
          Text(
            'Pick Avatar',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const Gap(50),
          Text(
            'Double tap an avatar to select it.',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: GridView.count(
                crossAxisCount: 4,
                childAspectRatio: 1.0,
                padding: const EdgeInsets.all(4.0),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                children: <Widget>[
                  for (int i = 0; i < LottieAvatar.values.length; i++) ...[
                    GestureDetector(
                      child: Column(
                        children: [
                          Lottie.asset(
                            LottieAvatar.values[i].path,
                            height: 100,
                          ),
                          if (LottieAvatar.values[i] == selectedAvatar) ...[
                            Text(
                              LottieAvatar.values[i].displayName,
                              style: Theme.of(context).textTheme.displayLarge!,
                            ),
                          ]
                        ],
                      ),
                      onTap: () async {
                        ref
                            .read(Providers.selectedAvatarProvider.notifier)
                            .select(LottieAvatar.values[i]);
                      },
                    ),
                  ]
                ],
              ),
            ),
          ),
          if (selectedAvatar != null) ...[
            GGButtonWidget(
              title: 'Confirm',
              onPressed: () async {
                await ref
                    .read(Providers.selectedAvatarProvider.notifier)
                    .save();

                ModalService.showToast(
                  title: 'Avatar updated.',
                  toastificationType: ToastificationType.success,
                  icon: const Icon(Icons.check),
                  primaryColor: Colors.green,
                );

                if (!context.mounted) return;

                context.pop();
              },
            ),
            const Gap(20),
          ],
          GGButtonWidget(
            title: 'Back',
            onPressed: () => context.pop(),
          ),
          const Gap(20),
        ],
      ),
    );
  }
}
