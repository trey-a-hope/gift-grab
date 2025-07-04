import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab_ui/gift_grab_ui.dart';

import '../account.dart';

part 'social_provider_tile.dart';

class ProviderInfo {
  final String title;
  final String subtitle;
  final bool isLinked;
  final VoidCallback onLink;
  final VoidCallback onUnlink;

  const ProviderInfo({
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
            ModalUtil.showSuccess(title: state.success!);
          }
          if (isError) {
            ModalUtil.showError(title: state.error!);
          }
          context.read<AccountBloc>().add(ReadAccount());
        }
      },
      builder: (context, state) {
        final accountBloc = context.read<AccountBloc>();

        final providers = <ProviderInfo>[
          ProviderInfo(
            title: 'Email',
            subtitle: state.account?.email ?? '',
            isLinked: state.account?.email != '',
            onLink: () async {
              final result = await ModalUtil.showEmailPasswordDialog(
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
          ProviderInfo(
            title: 'Google',
            subtitle: state.account?.user.googleId ?? '',
            isLinked: state.account?.user.googleId != '',
            onLink: () => accountBloc.add(LinkGoogleAccount()),
            onUnlink: () => accountBloc.add(UnlinkGoogleAccount()),
          ),
          if (Platform.isIOS) ...{
            ProviderInfo(
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
                        .map(
                          (provider) => SocialProviderTile(provider),
                        )
                        .toList(),
                  ),
          ),
        );
      },
    );
  }
}
