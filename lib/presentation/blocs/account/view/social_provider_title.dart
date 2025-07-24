import 'package:flutter/material.dart';
import 'package:gift_grab/domain/entities/provider_info.dart';

class SocialProviderTile extends StatelessWidget {
  final ProviderInfo providerInfo;

  const SocialProviderTile(this.providerInfo, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.onInverseSurface,
        child: SwitchListTile(
          title: Text(providerInfo.title, style: theme.textTheme.headlineSmall),
          subtitle: Text(
            providerInfo.subtitle,
            style: theme.textTheme.bodyLarge,
          ),
          value: providerInfo.isLinked,
          onChanged: (bool? value) {
            if (value == null) return;
            value ? providerInfo.onLink() : providerInfo.onUnlink();
          },
        ),
      ),
    );
  }
}
