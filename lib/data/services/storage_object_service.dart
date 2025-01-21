import 'dart:convert';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:nakama/nakama.dart';

class StorageObjectService {
  static Future<int> getGamesPlayed(Session session, String? uid) async {
    try {
      final storageObjectList = await getNakamaClient().listStorageObjects(
        session: session,
        collection: Globals.storageObjects.collection,
        limit: 1,
        userId: uid,
      );

      late int gamesPlayed;

      if (storageObjectList.objects.isEmpty) {
        gamesPlayed = 0;
      } else {
        final storageObject = storageObjectList.objects.first;
        gamesPlayed =
            json.decode(storageObject.value)[Globals.storageObjects.value];
      }

      return gamesPlayed;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<void> updateGamesPlayed(Session session) async {
    final gamesPlayed = await getGamesPlayed(session, null);

    await getNakamaClient().writeStorageObjects(
      session: session,
      objects: [
        StorageObjectWrite(
          permissionRead: StorageReadPermission.publicRead,
          collection: Globals.storageObjects.collection,
          key: Globals.storageObjects.key,
          value: json.encode(
            {Globals.storageObjects.value: gamesPlayed + 1},
          ),
        )
      ],
    );
  }
}
