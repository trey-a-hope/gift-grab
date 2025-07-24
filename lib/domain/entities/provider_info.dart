import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ProviderInfo extends Equatable {
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

  @override
  List<Object?> get props => [title, subtitle, isLinked, onLink, onUnlink];
}
