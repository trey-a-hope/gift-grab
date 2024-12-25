// import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:gift_grab/domain/providers.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
// ignore: implementation_imports, depend_on_referenced_packages

class LoginScreen extends ConsumerWidget {
  // final TextEditingController _controller = TextEditingController();
  static const _usernameFormField = 'Username';

  final storage = const FlutterSecureStorage();

  const LoginScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var nakamaAuthProvider = ref.watch(Providers.nakamaAuthProvider);

    return GGScaffoldWidget(
      child: Center(
        child:

            // ElevatedButton(
            //   onPressed: () async {
            //     try {
            //       await NakamaService().authenticateEmail();
            //     } catch (e) {
            //       ModalService.showError(title: e.toString());
            //     }
            //   },
            //   child: const Text('Auth!'),
            // ),

            nakamaAuthProvider.when(
          data: (data) => data == false
              ? FlutterLogin(
                  // logo: const AssetImage(
                  //   "assets/images/${Globals.giftSprite}",
                  // ),
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
                  onLogin: (data) async => await _onLogin(
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

  /// Call notifier to sign-up user by email with username.
  Future<String?> _onSignUp({
    required String email,
    required String password,
    required WidgetRef ref,
    required String username,
  }) async {
    try {
      final res = await NakamaService().authenticateEmail(
        email: email,
        password: password,
        username: 'trey.codes',
        create: false,
      );

      return null;
    } catch (e) {
      // var error = e as GrpcError;
      // return error.message;

      return e.toString();
    }
  }

  /// Call notifier to login user by email.
  Future<String?> _onLogin({
    required String email,
    required String password,
    required WidgetRef ref,
  }) async {
    try {
      final res = await NakamaService().authenticateEmail(
        email: email,
        password: password,
        username: 'trey.codes',
        create: false,
      );

      await storage.write(key: 'refreshToken', value: res.refreshToken);

      debugPrint('Refresh Token: ${res.refreshToken}, Token: ${res.token}');

      await ref.read(Providers.nakamaAuthProvider.notifier).check();

      return null;
    } catch (e) {
      // var error = e as GrpcError;
      // return error.message;

      return e.toString();
    }
  }
}
// https://heroiclabs.com/docs/nakama/server-framework/go-runtime/
