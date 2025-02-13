import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/domain/blocs/account/account_bloc.dart';
import 'package:gift_grab/presentation/widgets/gg_input_field_widget.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:smart_bloc/smart_bloc.dart';
import 'package:go_router/go_router.dart';

class EditProfileScreen extends SmartBloc<AccountBloc, AccountState> {
  const EditProfileScreen({super.key});
  @override
  Widget buildLoadedContent(BuildContext context, dynamic state) {
    state = state as AccountLoaded;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Gap(32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GGInputFieldWidget(
            onChanged: (val) {
              context.read<AccountBloc>().add(UsernameChange(username: val));
            },
            initialValue: state.currentUsername,
            hintText: 'Enter username...',
          ),
        ),
        const Gap(16),
        ElevatedButton(
          onPressed: () {
            debugPrint('Save button pressed');
            context.read<AccountBloc>().add(
                  SaveAccount(username: state.currentUsername),
                );
          },
          child: Text(
            'Save',
            style: TextStyle(
              fontSize: Globals.isTablet ? 50 : 25,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void listener(BuildContext context, AccountState state) {
    super.listener(context, state);

    if (state is AccountSuccess) {
      context.pop(true);
      context.read<AccountBloc>().add(FetchAccount());
    }

    if (state is AccountError) {
      context.read<AccountBloc>().add(FetchAccount());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GGScaffoldWidget(
      title: 'Edit Profile',
      child: Center(
        child: BlocConsumer<AccountBloc, AccountState>(
          listener: listener,
          builder: builder,
        ),
      ),
    );
  }
}
