import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/data/services/modal_service.dart';
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
    final theme = Theme.of(context);

    return GGScaffoldWidget(
      child: Center(
        child: BlocBuilder<AccountBloc, AccountState>(
          builder: (context, state) {
            if (state is AccountLoading) {
              return const CircularProgressIndicator();
            }

            if (state is AccountError) {
              return Text('Error: ${state.message}');
            }

            if (state is AccountLoaded) {
              _controller.text = state.account.user.username ?? 'No Username';
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
                  const Gap(20),
                  SizedBox(
                    width: Globals.isTablet ? 400 : 200,
                    height: Globals.isTablet ? 100 : 50,
                    child: ElevatedButton(
                      onPressed: () => _attemptSaveUsername(context),
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
                      onPressed: () => context.goNamed(Globals.routes.settings),
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
            }

            return SizedBox();
          },
        ),
      ),
    );
  }

  void _attemptSaveUsername(BuildContext context) async {
    try {
      context.read<AccountBloc>().add(
            UpdateAccountEvent(username: _controller.text),
          );

      ModalService.showSuccess(
        title: 'Username has been updated.',
      );
    } catch (e) {
      ModalService.showError(
        title: e.toString(),
      );
    }
  }
}
