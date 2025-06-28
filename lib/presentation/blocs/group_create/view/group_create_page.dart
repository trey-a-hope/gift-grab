import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/domain/services/session_service.dart';
import 'package:gift_grab_ui/gift_grab_ui.dart';
import 'package:nakama/nakama.dart';

import '../group_create.dart';

class GroupCreatePage extends StatelessWidget {
  final Group? group;

  const GroupCreatePage({
    this.group,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GroupCreateBloc(
        context.read<SessionService>(),
        group: group,
      )..add(Init()),
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
          ModalUtil.showError(title: state.error!);
        }
        if (state.success != null) {
          ModalUtil.showSuccess(title: state.success!);
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
                        child: ShortTextInput(
                          state.name,
                          labelText: 'Name',
                          onChanged: (name) => context
                              .read<GroupCreateBloc>()
                              .add(NameChanged(name)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsGeometry.all(16),
                        child: LongTextInput(
                          state.description,
                          labelText: 'Description',
                          helperText:
                              'Describe your group (${state.description.value.length}/${LongText.max})',
                          onChanged: (name) => context
                              .read<GroupCreateBloc>()
                              .add(DescriptionChanged(name)),
                        ),
                      ),
                      if (state.isNew) ...[
                        Padding(
                          padding: EdgeInsetsGeometry.all(16),
                          child: RangeInput(
                            state.maxCount,
                            title: 'Member Limit',
                            onChanged: (val) => context
                                .read<GroupCreateBloc>()
                                .add(MaxCountChanged(val.toInt())),
                          ),
                        ),
                      ],
                      Padding(
                        padding: EdgeInsetsGeometry.all(16),
                        child: ToggleInput(
                          state.isOpen,
                          title: 'Group Is Open',
                          subtitle:
                              'Open groups do not require request acceptance',
                          onChanged: (val) => context
                              .read<GroupCreateBloc>()
                              .add(IsOpenChanged(val)),
                        ),
                      ),
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
                              final confirm = await ModalUtil.showConfirmation(
                                context,
                                title: 'Submit Group',
                                message: 'Are you sure?',
                              );

                              if (confirm != true) {
                                return;
                              }

                              _groupCreateBloc.add(SubmitForm());
                            } else {
                              ModalUtil.showError(title: 'Form not valid');
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
