import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gift_grab/util/config/globals.dart';
import 'package:gift_grab/util/config/providers.dart';
import 'package:gift_grab/presentation/widgets/screen_background_widget.dart';
import 'package:gift_grab/util/upper_case_text_formatter.dart';

class LoginScreen extends ConsumerWidget {
  final TextEditingController _controller = TextEditingController();

  LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var nakamaSession = ref.watch(Providers.nakamaSessionAsyncNotifierProvider);
    var nakamaSessionAsyncNotifier =
        ref.read(Providers.nakamaSessionAsyncNotifierProvider.notifier);

    checkDeviceType(context);
    final theme = Theme.of(context);

    return ScreenBackgroundWidget(
      child: Center(
        child: nakamaSession.when(
          data: (data) => data == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50),
                      child: Text(
                        'Login',
                        style: theme.textTheme.displayLarge!.copyWith(
                          fontSize: Globals.isTablet
                              ? theme.textTheme.displayLarge!.fontSize! * 2
                              : theme.textTheme.displayLarge!.fontSize,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextFormField(
                        controller: _controller,
                        textAlign: TextAlign.center,
                        maxLength: 4,
                        inputFormatters: [
                          UpperCaseTextFormatter(),
                        ],
                        style: theme.textTheme.displayLarge!.copyWith(
                          fontSize: Globals.isTablet
                              ? theme.textTheme.displayLarge!.fontSize! * 2
                              : theme.textTheme.displayLarge!.fontSize,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.1),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: Globals.isTablet ? 400 : 200,
                      height: Globals.isTablet ? 100 : 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            String username = _controller.text;

                            nakamaSessionAsyncNotifier.authEmailPassword(
                              email: '$username@gmail.com',
                              password: 'password',
                              username: username,
                            );
                          } catch (e) {
                            if (!context.mounted) return;
                            final scaffoldMessenger =
                                ScaffoldMessenger.of(context);
                            scaffoldMessenger.showMaterialBanner(
                              MaterialBanner(
                                content: Text(e.toString()),
                                actions: [
                                  TextButton(
                                    onPressed: () => scaffoldMessenger
                                        .hideCurrentMaterialBanner(),
                                    child: const Text('DISMISS'),
                                  )
                                ],
                              ),
                            );
                          }
                        },
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: Globals.isTablet ? 50 : 25,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : const Text('Bro, you are logged in!'),
          loading: () => const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            ),
          ),
          error: (Object e, StackTrace stackTrace) => Text(
            e.toString(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 50,
            ),
          ),
        ),
      ),
    );
  }

  // Sets the global isTablet variable based on the device type/dimensions.
  Future<void> checkDeviceType(BuildContext context) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      Globals.isTablet = iosInfo.model.contains('iPad');
    } else {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      Globals.isTablet = (androidInfo.isPhysicalDevice &&
          MediaQuery.of(context).size.width >= 600.0);
    }
  }
}
