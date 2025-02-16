import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/services/modal_service.dart';
import 'package:gift_grab/domain/blocs/account/account_bloc.dart';
import 'package:gift_grab/presentation/extensions/build_context_extensions.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:smart_bloc/smart_bloc.dart';

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

class LinkedAccountsScreen extends SmartBloc<AccountBloc, AccountState> {
  const LinkedAccountsScreen({super.key});

  @override
  Widget buildLoadedContent(BuildContext context, dynamic state) =>
      _buildAccountContent(context, state as AccountLoaded);

  @override
  void listener(BuildContext context, AccountState state) {
    super.listener(context, state);

    if (state is AccountSuccess) {
      context.read<AccountBloc>().add(FetchAccount());
    }
  }

  @override
  Widget build(BuildContext context) => GGScaffoldWidget(
        title: 'Linked Accounts',
        child: Center(
          child: BlocConsumer<AccountBloc, AccountState>(
            listenWhen: (previous, current) => context.listenWhen(
              'linkedAccounts',
            ),
            listener: listener,
            builder: builder,
          ),
        ),
      );

  Widget _buildAccountContent(BuildContext context, AccountLoaded state) {
    final user = state.account?.user;

    if (user == null) {
      throw Exception('User is null...');
    }

    final providers = <ProviderInfo>[
      ProviderInfo(
        title: 'Email',
        subtitle: state.account!.email ?? '',
        isLinked: state.account!.email != '',
        onLink: () async {
          final result =
              await ModalService.showEmailPasswordDialog(context: context);

          if (result == null) return;

          final email = result.$1;
          final password = result.$2;

          if (!context.mounted) return;

          context.read<AccountBloc>().add(
                LinkEmailAccount(
                  email: email,
                  password: password,
                ),
              );
        },
        onUnlink: () => context.read<AccountBloc>().add(UnlinkEmailAccount()),
      ),
      ProviderInfo(
        title: 'Google',
        subtitle: user.googleId ?? '',
        isLinked: user.googleId != '',
        onLink: () => context.read<AccountBloc>().add(LinkGoogleAccount()),
        onUnlink: () => context.read<AccountBloc>().add(UnlinkGoogleAccount()),
      ),
      ProviderInfo(
        title: 'Apple',
        subtitle: user.appleId ?? '',
        isLinked: user.appleId != '',
        onLink: () => context.read<AccountBloc>().add(LinkAppleAccount()),
        onUnlink: () => context.read<AccountBloc>().add(UnlinkAppleAccount()),
      ),
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: providers
          .map(
            (provider) => _buildSocialProviderTile(
              context: context,
              provider: provider,
            ),
          )
          .toList(),
    );
  }

  Widget _buildSocialProviderTile({
    required BuildContext context,
    required ProviderInfo provider,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.onInverseSurface,
        child: SwitchListTile(
          title: Text(provider.title, style: theme.textTheme.headlineMedium),
          subtitle:
              Text(provider.subtitle, style: theme.textTheme.headlineSmall),
          value: provider.isLinked,
          onChanged: (bool? value) {
            if (value == null) return;
            debugPrint('Toggling ${provider.title} connection: $value');
            value ? provider.onLink() : provider.onUnlink();
          },
        ),
      ),
    );
  }
}
