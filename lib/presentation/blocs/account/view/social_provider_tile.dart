part of 'linked_accounts_page.dart';

class SocialProviderTile extends StatelessWidget {
  final ProviderInfo provider;

  const SocialProviderTile(
    this.provider, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
            value ? provider.onLink() : provider.onUnlink();
          },
        ),
      ),
    );
  }
}
