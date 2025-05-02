import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/services/modal_service.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';

import '../account.dart';

class _ProviderInfo {
  final String title;
  final String subtitle;
  final bool isLinked;
  final VoidCallback onLink;
  final VoidCallback onUnlink;

  const _ProviderInfo({
    required this.title,
    required this.subtitle,
    required this.isLinked,
    required this.onLink,
    required this.onUnlink,
  });
}

class LinkedAccountsPage extends StatelessWidget {
  const LinkedAccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountBloc, AccountState>(
      listener: (BuildContext context, AccountState state) {
        final isSuccess = state.success != null;
        final isError = state.error != null;

        if (isSuccess || isError) {
          if (isSuccess) {
            ModalService.showSuccess(title: state.success!);
          }
          if (isError) {
            ModalService.showError(title: state.error!);
          }
          context.read<AccountBloc>().add(ReadAccount());
        }
      },
      builder: (context, state) {
        final accountBloc = context.read<AccountBloc>();

        final providers = <_ProviderInfo>[
          _ProviderInfo(
            title: 'Email',
            subtitle: state.account?.email ?? '',
            isLinked: state.account?.email != '',
            onLink: () async {
              final result = await ModalService.showEmailPasswordDialog(
                context: context,
              );

              if (result == null) return;

              final email = result.$1;
              final password = result.$2;

              if (!context.mounted) return;

              accountBloc
                  .add(LinkEmailAccount(email: email, password: password));
            },
            onUnlink: () => accountBloc.add(UnlinkEmailAccount()),
          ),
          _ProviderInfo(
            title: 'Google',
            subtitle: state.account?.user.googleId ?? '',
            isLinked: state.account?.user.googleId != '',
            onLink: () => accountBloc.add(LinkGoogleAccount()),
            onUnlink: () => accountBloc.add(UnlinkGoogleAccount()),
          ),
          if (Platform.isIOS) ...{
            _ProviderInfo(
              title: 'Apple',
              subtitle: state.account?.user.appleId ?? '',
              isLinked: state.account?.user.appleId != '',
              onLink: () => accountBloc.add(LinkAppleAccount()),
              onUnlink: () => accountBloc.add(UnlinkAppleAccount()),
            ),
          }
        ];

        return GGScaffoldWidget(
          title: 'Linked Accounts',
          child: Center(
            child: state.isLoading
                ? CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: providers
                        .map((provider) =>
                            _buildSocialProviderTile(context, provider))
                        .toList(),
                  ),
          ),
        );
      },
    );
  }
}

Widget _buildSocialProviderTile(BuildContext context, _ProviderInfo provider) {
  final theme = Theme.of(context);

  return Padding(
    padding: const EdgeInsets.all(16),
    child: Material(
      borderRadius: BorderRadius.circular(16),
      color: theme.colorScheme.onInverseSurface,
      child: SwitchListTile(
        title: Text(provider.title, style: theme.textTheme.headlineMedium),
        subtitle: Text(provider.subtitle, style: theme.textTheme.headlineSmall),
        value: provider.isLinked,
        onChanged: (bool? value) {
          if (value == null) return;
          value ? provider.onLink() : provider.onUnlink();
        },
      ),
    ),
  );
}
