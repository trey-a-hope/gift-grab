import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gift_grab/data/services/hive_session_service.dart';
import 'package:gift_grab/data/services/modal_service.dart';
import 'package:nakama/nakama.dart';
import 'package:grpc/src/shared/status.dart';
import 'package:toastification/toastification.dart';

/// Provides a list of groups based on group search criteria.
class NakamaGroupsNotifier extends AsyncNotifier<List<Group>> {
  /// HiveSessionService instance.
  final _hiveSessionService = HiveSessionService();

  @override
  FutureOr<List<Group>> build() async {
    // Fetch the current session.
    final session = await _hiveSessionService.sessionActive();

    // If session is null, return empty list.
    if (session == null) {
      return [];
    }

    final groupList = await getNakamaClient().listGroups(
      session: session,
    );

    return groupList.groups;
  }

  Future deleteGroup({
    required Group group,
  }) async {
    // Fetch the current session.
    final session = await _hiveSessionService.sessionActive();

    // If session is null, return empty list.
    if (session == null) {
      return;
    }

    try {
      await getNakamaClient().deleteGroup(
        session: session,
        groupId: group.id,
      );

      // Get current list of groups.
      final currentList = state.value!.toList();

      // Remove group from the FE.
      currentList.removeWhere((g) => g.id == group.id);

      state = AsyncData(currentList);

      ModalService.showToast(
        title: 'Group "${group.name}" deleted.',
        toastificationType: ToastificationType.success,
        icon: const Icon(Icons.check),
        primaryColor: Colors.green,
      );
    } catch (e) {
      final error = e as GrpcError;
      ModalService.showToast(
        title: error.message ?? 'Unknown Error',
        toastificationType: ToastificationType.error,
        icon: const Icon(Icons.error),
        primaryColor: Colors.red,
      );
    }
  }

  Future createGroup({
    required String name,
    String? description,
    int? maxCount,
    bool? open,
  }) async {
    // Fetch the current session.
    final session = await _hiveSessionService.sessionActive();

    // If session is null, return empty list.
    if (session == null) {
      return;
    }

    try {
      final newGroup = await getNakamaClient().createGroup(
        session: session,
        name: name,
        description: description,
        maxCount: maxCount,
        open: open,
      );

      ModalService.showToast(
        title: 'Group "${newGroup.name}" created.',
        toastificationType: ToastificationType.success,
        icon: const Icon(Icons.check),
        primaryColor: Colors.green,
      );

      final cur = state.value!;

      state = AsyncData([...cur, newGroup]);
    } catch (e) {
      final error = e as GrpcError;
      ModalService.showToast(
        title: error.message ?? 'Unknown Error',
        toastificationType: ToastificationType.error,
        icon: const Icon(Icons.lock_clock),
        primaryColor: Colors.red,
      );
    }
    return;
  }
}
