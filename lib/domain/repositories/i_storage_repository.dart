// domain/repositories/i_storage_repository.dart
import 'package:nakama/nakama.dart';

abstract class IStorageRepository {
  Future<Map<String, dynamic>> getStorageObject({
    required Session session,
    required String collection,
    required String key,
    String? userId,
  });

  Future<void> writeStorageObject({
    required Session session,
    required String collection,
    required String key,
    required Map<String, dynamic> value,
  });
}
