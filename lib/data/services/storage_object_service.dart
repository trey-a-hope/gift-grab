import 'dart:convert';
import 'package:nakama/nakama.dart';

class StorageObjectService {
  static const _collection = 'game_info';
  static const _key = 'player_stats';
  static const _value = 'games_played';

  static Future<int> getGamesPlayed(
    Session session,
    String? uid,
  ) async {
    try {
      final storageObjectList = await getNakamaClient().listStorageObjects(
        session: session,
        collection: _collection,
        limit: 1,
        userId: uid,
      );

      if (storageObjectList.objects.isEmpty) {
        return 0;
      } else {
        final storageObject = storageObjectList.objects.first;
        return json.decode(storageObject.value)[_value];
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<void> updateGamesPlayed(
    Session session,
  ) async {
    final gamesPlayed = await getGamesPlayed(session, null);

    await getNakamaClient().writeStorageObjects(
      session: session,
      objects: [
        StorageObjectWrite(
          permissionRead: StorageReadPermission.publicRead,
          collection: _collection,
          key: _key,
          value: json.encode({_value: gamesPlayed + 1}),
        )
      ],
    );
  }
}
