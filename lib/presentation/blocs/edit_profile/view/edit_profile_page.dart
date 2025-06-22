import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/data/services/modal_service.dart';
import 'package:gift_grab/presentation/blocs/account/account.dart';
import 'package:gift_grab/presentation/blocs/auth/bloc/auth_bloc.dart';
import 'package:gift_grab/presentation/formz_inputs/name_input.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:go_router/go_router.dart';

import '../edit_profile.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditProfileBloc(
        context.read<AuthBloc>(),
        context.read<AccountBloc>(),
      ),
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
          ModalService.showSuccess(title: 'Profile updated');
        }

        if (state.status == FormzSubmissionStatus.failure) {
          ModalService.showError(title: 'Sorry, something went wrong');
        }
      },
      builder: (context, state) {
        final editProfileBloc = context.read<EditProfileBloc>();

        return GGScaffoldWidget(
          title: 'Edit Profile',
          child: Center(
            child: state.status == FormzSubmissionStatus.inProgress
                ? CircularProgressIndicator()
                : Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Gap(32),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: NameInput(
                            state.username,
                            onChanged: (name) => editProfileBloc.add(
                              UsernameChanged(name),
                            ),
                          ),
                        ),
                        const Gap(16),
                        ElevatedButton(
                          onPressed: () async {
                            final inputs = <FormzInput>[
                              state.username,
                            ];

                            final inputsValid = Formz.validate(inputs);

                            if (inputsValid) {
                              final confirm =
                                  await ModalService.showConfirmation(
                                context,
                                title: 'Save profile',
                                message: 'Are you sure?',
                              );

                              if (confirm != true) {
                                return;
                              }

                              editProfileBloc.add(SaveForm());
                            } else {
                              ModalService.showError(title: 'Form not valid');
                            }
                          },
                          child: Text('Save'),
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
