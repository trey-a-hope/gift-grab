// data/repositories/storage_repository.dart
import 'dart:convert';
import 'package:gift_grab/domain/repositories/i_storage_repository.dart';
import 'package:nakama/nakama.dart';

class StorageRepository implements IStorageRepository {
  final NakamaBaseClient _nakamaClient;

  StorageRepository(this._nakamaClient);

  @override
  Future<Map<String, dynamic>> getStorageObject({
    required Session session,
    required String collection,
    required String key,
    String? userId,
  }) async {
    try {
      final storageObjectList = await _nakamaClient.listStorageObjects(
        session: session,
        collection: collection,
        limit: 1,
        userId: userId,
      );

      if (storageObjectList.objects.isEmpty) {
        return {};
      }

      return json.decode(storageObjectList.objects.first.value);
    } catch (e) {
      throw Exception('Failed to get storage object: $e');
    }
  }

  @override
  Future<void> writeStorageObject({
    required Session session,
    required String collection,
    required String key,
    required Map<String, dynamic> value,
  }) async {
    try {
      await _nakamaClient.writeStorageObjects(
        session: session,
        objects: [
          StorageObjectWrite(
            permissionRead: StorageReadPermission.publicRead,
            collection: collection,
            key: key,
            value: json.encode(value),
          )
        ],
      );
    } catch (e) {
      throw Exception('Failed to write storage object: $e');
    }
  }
}
