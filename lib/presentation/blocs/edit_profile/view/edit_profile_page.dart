import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/domain/services/session_service.dart';
import 'package:gift_grab/presentation/blocs/account/account.dart';
import 'package:gift_grab_ui/formz_inputs/short_text/short_text_input.dart';
import 'package:gift_grab_ui/widgets/gg_scaffold_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_util/modal_util.dart';

import '../edit_profile.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditProfileBloc(
        context.read<AccountBloc>(),
        context.read<SessionService>(),
      )..add(const Init()),
      child: const EditProfileView(),
    );
  }
}

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditProfileBloc, EditProfileState>(
      listener: (context, state) {
        if (state.status == FormzSubmissionStatus.success) {
          context.pop(true);
          ModalUtil.showSuccess(context, title: 'Profile updated');
        }

        if (state.status == FormzSubmissionStatus.failure) {
          ModalUtil.showError(context,
              title: 'Could not save form, please try again');
        }
      },
      builder: (context, state) {
        final bloc = context.read<EditProfileBloc>();

        return GGScaffoldWidget(
          title: 'Edit Profile',
          child: Center(
            child: state.status == FormzSubmissionStatus.inProgress
                ? const CircularProgressIndicator()
                : Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ShortTextInput(
                          state.username,
                          labelText: 'Username',
                          onChanged: (name) => bloc.add(
                            UsernameChanged(name),
                          ),
                        ),
                        const Gap(16),
                        ElevatedButton(
                          onPressed: () async {
                            final inputs = [state.username];

                            final inputsValid = Formz.validate(inputs);

                            if (!inputsValid)
                              ModalUtil.showError(
                                context,
                                title: 'Form not valid',
                              );

                            final confirm = await ModalUtil.showConfirmation(
                              context,
                              title: 'Save profile',
                              message: 'Are you sure?',
                            );

                            if (confirm != true) return;

                            bloc.add(const SaveForm());
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
