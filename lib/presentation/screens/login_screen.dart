import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gift_grab/domain/repositories/auth_stream_repository.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';

class LoginScreen extends StatelessWidget {
  static const _usernameFormField = 'Username';
  static const _savedEmail = 'trey.a.hope@gmail.com';
  static const _savedPassword = 'Peachy5050';

  final AuthStreamRepository authStreamRepository;

  const LoginScreen(this.authStreamRepository, {super.key});

  @override
  Widget build(BuildContext context) {
    return GGScaffoldWidget(
      title: 'Login',
      canPop: false,
      child: FlutterLogin(
        savedEmail: _savedEmail,
        savedPassword: _savedPassword,
        title: 'Gift Grab',
        theme: LoginTheme(
          primaryColor: Colors.blue,
          accentColor: Colors.white,
        ),
        onLogin: (data) async => await _onLoginEmail(
          context: context,
          email: data.name,
          password: data.password,
        ),
        loginProviders: [
          LoginProvider(
            icon: FontAwesomeIcons.google,
            label: 'Google',
            callback: () async => await _onLoginGoogle(
              context: context,
            ),
          ),
          if (Platform.isIOS) ...[
            LoginProvider(
              icon: FontAwesomeIcons.apple,
              label: 'Apple',
              callback: () async => await _onLoginApple(
                context: context,
              ),
            ),
          ]
        ],
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

          return _onSignUpEmail(
            context: context,
            email: data.name!,
            password: data.password!,
            username: data.additionalSignupData![_usernameFormField]!,
          );
        },
        onRecoverPassword: (val) => null,
      ),
    );
  }

  Future<String?> _onLoginEmail({
    required BuildContext context,
    required String email,
    required String password,
  }) async =>
      _handleAuthEvent(
        () => authStreamRepository.loginEmail(
          email,
          password,
        ),
      );

  Future<String?> _onSignUpEmail({
    required BuildContext context,
    required String email,
    required String password,
    required String username,
  }) async =>
      _handleAuthEvent(
        () => authStreamRepository.signup(
          email,
          password,
          username,
        ),
      );

  Future<String?> _onLoginGoogle({required BuildContext context}) async =>
      _handleAuthEvent(
        () => authStreamRepository.loginGoogle(),
      );

  Future<String?> _onLoginApple({required BuildContext context}) async =>
      _handleAuthEvent(
        () => authStreamRepository.loginApple(),
      );

  Future<String?> _handleAuthEvent(
    void Function() addEvent,
  ) async {
    try {
      final completer = Completer<String?>();
      late final StreamSubscription subscription;

      subscription = authStreamRepository.authStateStream.listen(
        (state) {
          if (!completer.isCompleted) {
            if (state.error != null) {
              completer.complete(state.error!);
              subscription.cancel();
            } else if (state.authenticated) {
              completer.complete(null);
              subscription.cancel();
            }
          }
        },
      );

      addEvent();

      return await completer.future;
    } catch (e) {
      return e.toString();
    }
  }
}
