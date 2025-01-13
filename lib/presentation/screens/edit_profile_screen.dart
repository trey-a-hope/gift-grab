import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/domain/blocs/account/account_bloc.dart';
import 'package:gift_grab/presentation/widgets/gg_input_field_widget.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/presentation/widgets/stateful_bloc.dart';
import 'package:go_router/go_router.dart';

class EditProfileScreen extends StatefulBloc<AccountBloc, AccountState> {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState
    extends StatefulBlocState<EditProfileScreen, AccountBloc, AccountState> {
  final _controller = TextEditingController();

  @override
  Widget buildLoadedContent(BuildContext context, dynamic state) {
    _controller.text = state.account.user.username ?? 'No Username';

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
  }

  @override
  bool shouldShowMessage(AccountState state) =>
      state is AccountError || state is AccountActionSuccess;

  @override
  void onAfterMessage(BuildContext context) =>
      context.read<AccountBloc>().add(FetchAccount());

  @override
  Widget build(BuildContext context) {
    return GGScaffoldWidget(
      title: 'Edit Profile',
      goBack: () => context.goNamed(Globals.routes.settings),
      child: Center(
        child: BlocConsumer<AccountBloc, AccountState>(
          listener: listener,
          builder: builder,
        ),
      ),
    );
  }
}
