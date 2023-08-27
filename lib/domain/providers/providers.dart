import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gift_grab/domain/providers/nakama_provider.dart';

class Providers {
  static final ref = ProviderContainer();

  static final nakamaProvider = ChangeNotifierProvider((_) => NakamaProvider());
}
