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
    await getNakamaClient().writeStorageObjects(
      session: session,
      objects: [
        StorageObjectWrite(
          collection: collection,
          key: session.userId,
          value: jsonEncode(value),
        )
      ],
    );
  }

  /// Return storage object as map.
  Future<Map<String, dynamic>?> read({
    required Session session,
    required String collection,
    required String key,
    required String userId,
  }) async {
    final storageObject = await getNakamaClient().readStorageObjects(
      session: session,
      objectIds: [
        StorageObjectId(
          collection: collection,
          key: key,
        )
      ],
    );

    throw UnimplementedError();

    // return jsonDecode(storageObject);
  }
}
