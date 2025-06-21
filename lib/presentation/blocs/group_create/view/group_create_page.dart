import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/data/services/modal_service.dart';
import 'package:gift_grab/presentation/blocs/auth/bloc/auth_bloc.dart';
import 'package:gift_grab/presentation/formz_inputs/comment.dart';
import 'package:gift_grab/presentation/formz_inputs/comment_input.dart';
import 'package:gift_grab/presentation/formz_inputs/name_input.dart';
import 'package:gift_grab/presentation/formz_inputs/slider_input.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';

import '../group_create.dart';

class GroupCreatePage extends StatelessWidget {
  const GroupCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GroupCreateBloc(context.read<AuthBloc>()),
      child: const GroupCreateView(),
    );
  }
}

class GroupCreateView extends StatelessWidget {
  const GroupCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    final _groupCreateBloc = context.read<GroupCreateBloc>();

    return BlocConsumer<GroupCreateBloc, GroupCreateState>(
      listener: (context, state) {
        if (state.error != null) {
          ModalService.showError(title: state.error!);
        }
        if (state.success != null) {
          ModalService.showSuccess(title: state.success!);
          Navigator.of(context).pop(true);
        }
      },
      builder: (context, state) {
        return GGScaffoldWidget(
          title: 'Create Group',
          child: SafeArea(
            child: state.status.isInProgress
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView(
                    padding: EdgeInsets.all(16),
                    children: [
                      Padding(
                        padding: EdgeInsetsGeometry.all(16),
                        child: NameInput(
                          state.name,
                          onChanged: (name) => context
                              .read<GroupCreateBloc>()
                              .add(NameChanged(name)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsGeometry.all(16),
                        child: CommentInput(
                          state.description,
                          labelText: 'Description',
                          helperText:
                              'Describe your group (${state.description.value.length}/${Comment.max})',
                          onChanged: (name) => context
                              .read<GroupCreateBloc>()
                              .add(DescriptionChanged(name)),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsetsGeometry.all(16),
                          child: SliderInput(
                            state.maxCount,
                            onChanged: (val) => context
                                .read<GroupCreateBloc>()
                                .add(MaxCountChanged(val.toInt())),
                          )),
                      // TODO: IS OPEN OG
                      Center(
                        child: ElevatedButton(
                          child: Text('Submit'),
                          onPressed: () async {
                            final inputs = <FormzInput>[
                              state.name,
                              state.description,
                              state.maxCount,
                            ];

                            final inputsValid = Formz.validate(inputs);

                            if (inputsValid) {
                              final confirm =
                                  await ModalService.showConfirmation(
                                context,
                                title: 'Submit Group',
                                message: 'Are you sure?',
                              );

                              if (confirm != true) {
                                return;
                              }

                              _groupCreateBloc.add(CreateGroup());
                            } else {
                              ModalService.showError(title: 'Form not valid');
                            }
                          },
                        ),
                      ),
                      const Gap(16),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
