import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/domain/entities/provider_info.dart';
import 'package:gift_grab/presentation/blocs/account/bloc/account_bloc.dart';
import 'package:gift_grab/presentation/blocs/account/view/social_provider_title.dart';
import 'package:gift_grab_ui/widgets/gg_scaffold_widget.dart';
import 'package:modal_util/modal_util.dart';

class LinkedAccountsPage extends StatelessWidget {
  const LinkedAccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LinkedAccountsView();
  }
}

class LinkedAccountsView extends StatelessWidget {
  const LinkedAccountsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountBloc, AccountState>(
      listener: (context, state) {
        final isSuccess = state.success != null;
        final isError = state.error != null;

        if (!isSuccess && !isError) return;

        if (isSuccess) {
          ModalUtil.showSuccess(context, title: state.success!);
        }

        if (isError) {
          ModalUtil.showError(context, title: state.error!);
        }

        context.read<AccountBloc>().add(const ReadAccount());
      },
      builder: (context, state) {
        final bloc = context.read<AccountBloc>();

        final providers = [
          ProviderInfo(
            title: 'Email',
            subtitle: state.account?.email ?? '',
            isLinked: state.account?.email != '',
            onLink: () async {
              final result = await ModalUtil.showEmailPasswordDialog(context);

              if (result == null) return;

              final email = result.$1;
              final password = result.$2;

              if (!context.mounted) return;

              bloc.add(LinkEmail(email: email, password: password));
            },
            onUnlink: () => bloc.add(
              const UnlinkEmail(),
            ),
          ),
          ProviderInfo(
            title: 'Google',
            subtitle: state.account?.user.googleId ?? '',
            isLinked: state.account?.user.googleId?.isNotEmpty ?? false,
            onLink: () => bloc.add(const LinkGoogle()),
            onUnlink: () => bloc.add(const UnlinkGoogle()),
          ),
          ProviderInfo(
            title: 'Apple',
            subtitle: state.account?.user.appleId ?? '',
            isLinked: state.account?.user.appleId?.isNotEmpty ?? false,
            onLink: () => bloc.add(const LinkApple()),
            onUnlink: () => bloc.add(const UnlinkApple()),
          ),
        ];

        return GGScaffoldWidget(
          title: 'Linked Accounts',
          child: Center(
            child: state.isLoading
                ? const CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: providers
                        .map((provider) => SocialProviderTile(provider))
                        .toList(),
                  ),
          ),
        );
      },
    );
  }
}
