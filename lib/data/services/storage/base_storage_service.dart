import 'dart:convert';
import 'package:nakama/nakama.dart';

part 'chat_storage.dart';
part 'games_played_storage.dart';
part 'direct_chat_storage.dart';

abstract class BaseStorageService<T> {
  String get collection;
  String get key;
  String get valueKey;

  T parseValue(dynamic json);
  Map<String, dynamic> serializeValue(T value);

  Future<T> getValue(Session session, String? uid) async {
    try {
      final storageObjectList = await getNakamaClient().listStorageObjects(
        session: session,
        collection: collection,
        limit: 1,
        userId: uid,
      );

      if (storageObjectList.objects.isEmpty) {
        return defaultValue;
      }
      return parseValue(
        json.decode(
          storageObjectList.objects.first.value,
        ),
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateValue(Session session, T newValue) async {
    await getNakamaClient().writeStorageObjects(
      session: session,
      objects: [
        StorageObjectWrite(
          permissionRead: StorageReadPermission.publicRead,
          collection: collection,
          key: key,
          value: json.encode(serializeValue(newValue)),
        )
      ],
    );
  }

  T get defaultValue;
}
