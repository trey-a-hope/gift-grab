import 'dart:convert';
import 'package:nakama/nakama.dart';

/// Service for reading/writing storage objects.
class NakamaStorageObjectService {
  /// Save storage object to collection.
  Future<void> write({
    required Session session,
    required String collection,
    required Map<String, dynamic> value,
  }) async {
    await getNakamaClient().writeStorageObject(
      session: session,
      collection: collection,
      key: session.userId,
      value: jsonEncode(value),
    );
  }

  /// Return storage object as map.
  Future<Map<String, dynamic>?> read({
    required Session session,
    required String collection,
    required String key,
    required String userId,
  }) async {
    final storageObject = await getNakamaClient().readStorageObject(
      session: session,
      collection: collection,
      key: key,
      userId: userId,
    );

    if (storageObject == null) return null;

    return jsonDecode(storageObject.value);
  }
}
