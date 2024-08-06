import 'package:flutter/material.dart';

/// Listens to changes in the app lifecycle and provides callbacks for each.
class LifecycleEventHandler extends AppLifecycleListener {
  final VoidCallback onHide_;
  final VoidCallback onDetach_;
  final VoidCallback onShow_;
  final VoidCallback onResume_;
  final VoidCallback onInactive_;
  final VoidCallback onPause_;
  final VoidCallback onRestart_;
  final ValueChanged<AppLifecycleState> onStateChange_;
  final AppExitRequestCallback onExitRequested_;

  LifecycleEventHandler({
    required this.onHide_,
    required this.onDetach_,
    required this.onShow_,
    required this.onResume_,
    required this.onInactive_,
    required this.onPause_,
    required this.onRestart_,
    required this.onStateChange_,
    required this.onExitRequested_,
  });

  @override
  VoidCallback? get onHide => onHide_;

  @override
  VoidCallback? get onDetach => onDetach_;

  @override
  VoidCallback? get onShow => onShow_;

  @override
  VoidCallback? get onRestart => onRestart_;

  @override
  VoidCallback? get onResume => onResume_;

  @override
  VoidCallback? get onInactive => onInactive_;

  @override
  VoidCallback? get onPause => onPause_;

  @override
  ValueChanged<AppLifecycleState>? get onStateChange => onStateChange_;

  @override
  AppExitRequestCallback? get onExitRequested => onExitRequested_;
}
