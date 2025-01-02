import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';

class LoginScreen extends StatelessWidget {
  static const _usernameFormField = 'Username';
  final storage = const FlutterSecureStorage();

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }

        if (state is Authenticated) {
          storage.write(key: 'refreshToken', value: state.token);
        }
      },
      child: GGScaffoldWidget(
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
      ),
    );
  }

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
