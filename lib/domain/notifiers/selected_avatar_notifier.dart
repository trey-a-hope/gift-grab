// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:gift_grab/data/constants/globals.dart';
// import 'package:gift_grab/domain/providers.dart';

// class SelectedAvatarNotifier extends Notifier<LottieAvatar?> {
//   @override
//   LottieAvatar? build() {
//     final sessionData = ref.watch(Providers.nakamaSessionDataProvider);

//     if (sessionData.value?.avatar != null &&
//         LottieAvatar.findByName(sessionData.value?.avatar) != null) {
//       return LottieAvatar.findByName(sessionData.value!.avatar);
//     }

//     return null;
//   }

//   Future save() async {
//     final currentAvatar = state;

//     if (currentAvatar == null) return;

//     await ref.read(Providers.nakamaSessionDataProvider.notifier).updateAvatar(
//           avatar: currentAvatar.name,
//         );
//   }

//   void select(LottieAvatar avatar) => state = avatar;
// }
