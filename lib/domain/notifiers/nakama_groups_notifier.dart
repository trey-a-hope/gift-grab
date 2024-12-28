// import 'dart:async';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:gift_grab/data/services/hive_session_service.dart';
// import 'package:gift_grab/data/services/modal_service.dart';
// import 'package:nakama/nakama.dart';
// // ignore: implementation_imports, depend_on_referenced_packages
// import 'package:grpc/src/shared/status.dart';

// /// Provides a list of groups based on group search criteria.
// class NakamaGroupsNotifier extends AsyncNotifier<List<Group>> {
//   @override
//   FutureOr<List<Group>> build() async {
//     throw UnimplementedError();
//   }

//   // Future joinGroup({required Group group}) async {
//   //   // Fetch the current session.
//   //   final session = await _hiveSessionService.sessionActive();

//   //   // If session is null, return empty list.
//   //   if (session == null) {
//   //     return;
//   //   }

//   //   try {
//   //     await getNakamaClient().joinGroup(
//   //       session: session,
//   //       groupId: group.id,
//   //     );

//   //     ModalService.showSuccess(
//   //       title: 'You have joined "${group.name}".',
//   //     );
//   //   } catch (e) {
//   //     final error = e as GrpcError;
//   //     ModalService.showError(
//   //       title: error.message ?? 'Unknown Error',
//   //     );
//   //   }
//   // }

//   // Future deleteGroup({
//   //   required Group group,
//   // }) async {
//   //   // Fetch the current session.
//   //   final session = await _hiveSessionService.sessionActive();

//   //   // If session is null, return empty list.
//   //   if (session == null) {
//   //     return;
//   //   }

//   //   try {
//   //     await getNakamaClient().deleteGroup(
//   //       session: session,
//   //       groupId: group.id,
//   //     );

//   //     // Get current list of groups.
//   //     final currentList = state.value!.toList();

//   //     // Remove group from the FE.
//   //     currentList.removeWhere((g) => g.id == group.id);

//   //     state = AsyncData(currentList);

//   //     ModalService.showSuccess(
//   //       title: 'Group "${group.name}" deleted.',
//   //     );
//   //   } catch (e) {
//   //     final error = e as GrpcError;
//   //     ModalService.showError(
//   //       title: error.message ?? 'Unknown Error',
//   //     );
//   //   }
//   // }

//   // Future createGroup({
//   //   required String name,
//   //   String? description,
//   //   int? maxCount,
//   //   bool? open,
//   // }) async {
//   //   // Fetch the current session.
//   //   final session = await _hiveSessionService.sessionActive();

//   //   // If session is null, return empty list.
//   //   if (session == null) {
//   //     return;
//   //   }

//   //   try {
//   //     final newGroup = await getNakamaClient().createGroup(
//   //       session: session,
//   //       name: name,
//   //       description: description,
//   //       maxCount: maxCount,
//   //       open: open,
//   //     );

//   //     ModalService.showSuccess(
//   //       title: 'Group "${newGroup.name}" created.',
//   //     );

//   //     final cur = state.value!;

//   //     state = AsyncData([...cur, newGroup]);
//   //   } catch (e) {
//   //     final error = e as GrpcError;
//   //     ModalService.showError(
//   //       title: error.message ?? 'Unknown Error',
//   //     );
//   //   }
//   //   return;
//   // }
// }
