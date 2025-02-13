import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/domain/blocs/account/account_bloc.dart';
import 'package:gift_grab/presentation/extensions/build_context_extensions.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:smart_bloc/smart_bloc.dart';

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
    final user = state.account!.user;
    final providers = [
      {
        'title': 'Email',
        'subtitle': state.account!.email ?? '',
        'isLinked': state.account!.email != '',
        'onLink': () => context.read<AccountBloc>().add(LinkEmailAccount()),
        'onUnlink': () => context.read<AccountBloc>().add(UnlinkEmailAccount()),
      },
      {
        'title': 'Google',
        'subtitle': user.googleId ?? '',
        'isLinked': user.googleId != '',
        'onLink': () => context.read<AccountBloc>().add(LinkGoogleAccount()),
        'onUnlink': () =>
            context.read<AccountBloc>().add(UnlinkGoogleAccount()),
      },
      {
        'title': 'Apple',
        'subtitle': user.appleId ?? '',
        'isLinked': user.appleId != '',
        'onLink': () => context.read<AccountBloc>().add(LinkAppleAccount()),
        'onUnlink': () => context.read<AccountBloc>().add(UnlinkAppleAccount()),
      },
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: providers
          .map((provider) => _buildSocialProviderTile(
                context: context,
                title: provider['title'] as String,
                subtitle: provider['subtitle'] as String,
                isLinked: provider['isLinked'] as bool,
                onLink: provider['onLink'] as VoidCallback,
                onUnlink: provider['onUnlink'] as VoidCallback,
              ))
          .toList(),
    );
  }

  Widget _buildSocialProviderTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool isLinked,
    required VoidCallback onLink,
    required VoidCallback onUnlink,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.onInverseSurface,
        child: SwitchListTile(
          title: Text(title, style: theme.textTheme.headlineMedium),
          subtitle: Text(subtitle, style: theme.textTheme.headlineSmall),
          value: isLinked,
          onChanged: (bool? value) {
            if (value == null) return;
            debugPrint('Toggling $title connection: $value');
            value ? onLink() : onUnlink();
          },
        ),
      ),
    );
  }
}
