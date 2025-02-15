import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';

class AuthInfo {
  final String email;
  final String password;

  const AuthInfo({required this.email, required this.password});
}

class LoginScreen extends StatelessWidget {
  static const _usernameFormField = 'Username';

  static const _authInfos = <AuthInfo>[
    AuthInfo(email: 'trey.a.hope@gmail.com', password: 'Peachy4040'),
  ];

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authInfo = _authInfos[Random().nextInt(_authInfos.length)];

    return GGScaffoldWidget(
      title: 'Login',
      canPop: false,
      child: FlutterLogin(
        title: 'Gift Grab',
        savedEmail: authInfo.email,
        savedPassword: authInfo.password,
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

          return _onSignUpEmail(
            context: context,
            email: data.name!,
            password: data.password!,
            username: data.additionalSignupData![_usernameFormField]!,
          );
        },
        onRecoverPassword: (email) {
          return null;
        },
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
      ),
    );
  }

  Future<String?> _onSignUpEmail({
    required BuildContext context,
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final completer = Completer<String?>();

      late final StreamSubscription subscription;
      subscription = context.read<AuthBloc>().stream.listen(
        (state) {
          if (state is AuthError && !completer.isCompleted) {
            completer.complete(state.message);
            subscription.cancel();
          } else if (state is Authenticated && !completer.isCompleted) {
            completer.complete(null);
            subscription.cancel();
          }
        },
      );

      context.read<AuthBloc>().add(
            SignUpEmail(
              email: email,
              password: password,
              username: username,
            ),
          );

      return await completer.future;
    } catch (e) {
      return e.toString();
    }
  }

  // Note, there is no GoogleSignUp with FlutterLogin package.
  Future<String?> _onLoginEmail({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    final completer = Completer<String?>();

    email = 'trey.a.hope@gmail.com';
    password = 'Peachy4040';

    late final StreamSubscription subscription;
    subscription = context.read<AuthBloc>().stream.listen(
      (state) {
        if (state is AuthError && !completer.isCompleted) {
          completer.complete(state.message);
          subscription.cancel();
        } else if (state is Authenticated && !completer.isCompleted) {
          completer.complete(null);
          subscription.cancel();
        }
      },
    );

    context.read<AuthBloc>().add(
          LoginEmail(
            email: email,
            password: password,
          ),
        );

    return await completer.future;
  }

  Future<String?> _onLoginGoogle({
    required BuildContext context,
  }) async {
    final completer = Completer<String?>();

    late final StreamSubscription subscription;
    subscription = context.read<AuthBloc>().stream.listen(
      (state) {
        if (state is AuthError && !completer.isCompleted) {
          completer.complete(state.message);
          subscription.cancel();
        } else if (state is Authenticated && !completer.isCompleted) {
          completer.complete(null);
          subscription.cancel();
        }
      },
    );

    context.read<AuthBloc>().add(LoginGoogle());

    return await completer.future;
  }

  Future<String?> _onLoginApple({
    required BuildContext context,
  }) async {
    final completer = Completer<String?>();

    late final StreamSubscription subscription;
    subscription = context.read<AuthBloc>().stream.listen(
      (state) {
        if (state is AuthError && !completer.isCompleted) {
          completer.complete(state.message);
          subscription.cancel();
        } else if (state is Authenticated && !completer.isCompleted) {
          completer.complete(null);
          subscription.cancel();
        }
      },
    );

    context.read<AuthBloc>().add(LoginApple());

    return await completer.future;
  }
}
