import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/domain/blocs/account/account_bloc.dart';
import 'package:gift_grab/presentation/widgets/gg_input_field_widget.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:go_router/go_router.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GGScaffoldWidget(
      title: 'Edit Profile',
      goBack: () => context.goNamed(Globals.routes.settings),
      child: Center(
        child: BlocConsumer<AccountBloc, AccountState>(
          listener: (context, state) {
            if (state is AccountError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );

              context.read<AccountBloc>().add(FetchAccount());
            }
            if (state is AccountActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );

              context.read<AccountBloc>().add(FetchAccount());
            }
          },
          builder: (context, state) => switch (state) {
            AccountLoading() =>
              Center(child: const CircularProgressIndicator()),
            AccountLoaded() => Builder(
                builder: (_) {
                  _controller.text =
                      state.account.user.username ?? 'No Username';

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Gap(32),
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
                      const Gap(16),
                      ElevatedButton(
                        onPressed: () => context.read<AccountBloc>().add(
                              UpdateAccount(username: _controller.text),
                            ),
                        child: Text(
                          'Save',
                          style: TextStyle(
                            fontSize: Globals.isTablet ? 50 : 25,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            AccountError() => Text('Error: ${state.message}'),
            _ => Text('hello')
          },
        ),
      ),
    );
  }
}
