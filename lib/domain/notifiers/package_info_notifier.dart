import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Provides application bundle information on iOS and application package information on Android.
class PackageInfoNotifier extends AsyncNotifier<PackageInfo> {
  @override
  FutureOr<PackageInfo> build() async => await PackageInfo.fromPlatform();
}
