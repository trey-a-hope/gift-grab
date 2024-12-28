// import 'package:flutter/material.dart';
// import 'package:gift_grab/data/constants/globals.dart';
// import 'package:nakama/nakama.dart';

// class GroupMemberDetailsWidget extends StatelessWidget {
//   final GroupUser groupUser;

//   const GroupMemberDetailsWidget({
//     required this.groupUser,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     final groupMembershipState = groupUser.state;

//     final user = groupUser.user;

//     return ListTile(
//       leading: CircleAvatar(
//         backgroundImage: Image.network(
//           user.avatarUrl == null || user.avatarUrl!.isEmpty
//               ? Globals.emptyProfile
//               : user.avatarUrl!,
//         ).image,
//       ),
//       title: Text(
//         user.username ?? 'No Display Name',
//         style: theme.textTheme.displayMedium,
//       ),
//       subtitle: Text(
//         groupMembershipState.name,
//         style: theme.textTheme.displaySmall,
//       ),
//       trailing: user.online
//           ? const CircleAvatar(
//               child: Icon(Icons.online_prediction_outlined),
//             )
//           : const CircleAvatar(
//               child: Icon(Icons.bed_outlined),
//             ),
//     );
//   }
// }
