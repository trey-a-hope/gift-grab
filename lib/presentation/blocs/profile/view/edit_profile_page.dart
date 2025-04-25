import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/data/services/modal_service.dart';
import 'package:gift_grab/presentation/blocs/account/account.dart';
import 'package:gift_grab/presentation/widgets/gg_input_field_widget.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:go_router/go_router.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state.success != null) {
          context.pop(true);
          ModalService.showSuccess(title: state.success!);
        }

        if (state.error != null) {
          ModalService.showError(title: state.error!);
        }

        context.read<AccountBloc>().add(ReadAccount());
      },
      builder: (context, state) {
        final accountBloc = context.read<AccountBloc>();

        return GGScaffoldWidget(
          title: 'Edit Profile',
          child: Center(
            child: state.isLoading
                ? CircularProgressIndicator()
                : Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Gap(32),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: GGInputFieldWidget(
                            onChanged: (val) =>
                                accountBloc.add(UsernameChange(val)),
                            initialValue: state.currentUsername,
                            hintText: 'Enter username...',
                          ),
                        ),
                        const Gap(16),
                        ElevatedButton(
                          onPressed: () => accountBloc.add(UpdateAccount()),
                          child: Text('Save', style: TextStyle(fontSize: 50)),
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
