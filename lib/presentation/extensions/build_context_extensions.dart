import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension BuildContextExtensions on BuildContext {
  // Apply to Bloc Consumers that listen to the same bloc on different pages.
  bool listenWhen(String title) =>
      GoRouterState.of(this).uri.path.endsWith(title);
}
