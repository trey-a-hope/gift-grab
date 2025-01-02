import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';

class LoginScreen extends StatelessWidget {
  static const _usernameFormField = 'Username';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) => GGScaffoldWidget(
        child: FlutterLogin(
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
              context: context,
              email: data.name!,
              password: data.password!,
              username: data.additionalSignupData![_usernameFormField]!,
            );
          },
          onRecoverPassword: (email) {
            return null;
          },
          onLogin: (data) async => await _onLogin(
            context: context,
            email: data.name,
            password: data.password,
          ),
        ),
      );

  Future<String?> _onSignUp({
    required BuildContext context,
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      context.read<AuthBloc>().add(
            SignUpEvent(
              email: email,
              password: password,
              username: username,
            ),
          );
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> _onLogin({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    // TODO: Handle error with login; currently just goes blank if incorrect auth.
    try {
      context.read<AuthBloc>().add(
            LoginEvent(
              email: email,
              password: password,
            ),
          );
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
