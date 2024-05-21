import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gift_grab/domain/providers.dart';
import 'package:gift_grab/presentation/widgets/screen_background_widget.dart';
import 'package:gift_grab/data/constants/globals.dart';

class LoginScreen extends ConsumerWidget {
  // final TextEditingController _controller = TextEditingController();
  static const _usernameFormField = 'Username';

  const LoginScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var nakamaAuthProvider = ref.watch(Providers.nakamaAuthProvider);

    checkDeviceType(context);

    return ScreenBackgroundWidget(
      child: Center(
        child: nakamaAuthProvider.when(
          data: (data) => data == false
              ? FlutterLogin(
                  title: 'Gift Grab',
                  theme: LoginTheme(
                    primaryColor: Colors.blueAccent,
                    accentColor: Colors.white,
                  ),
                  additionalSignupFields: const [
                    UserFormField(
                      icon: Icon(Icons.face),
                      keyName: _usernameFormField,
                    ),
                  ],
                  onSignup: (data) async {
                    if (data.name == null ||
                        data.password == null ||
                        data.additionalSignupData == null) {
                      return 'Email/Password/Username cannot be null...';
                    }

                    return _onSignUp(
                      email: data.name!,
                      password: data.password!,
                      username: data.additionalSignupData![_usernameFormField]!,
                      ref: ref,
                    );
                  },
                  onRecoverPassword: (email) {
                    //TODO: Send email...
                    return null;
                  },
                  onLogin: (data) => _onLogin(
                    email: data.name,
                    password: data.password,
                    ref: ref,
                  ),
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

  Future<String?> _onSignUp({
    required String email,
    required String password,
    required WidgetRef ref,
    required String username,
  }) async {
    try {
      await ref.read(Providers.nakamaAuthProvider.notifier).authenticateEmail(
            email: email,
            password: password,
            username: username,
            create: true,
          );

      return null;
    } catch (error) {
      return error.toString();
    }
  }

  Future<String?> _onLogin({
    required String email,
    required String password,
    required WidgetRef ref,
  }) async {
    try {
      await ref.read(Providers.nakamaAuthProvider.notifier).authenticateEmail(
            email: email,
            password: password,
            create: false,
          );

      return null;
    } catch (error) {
      return error.toString();
    }
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
