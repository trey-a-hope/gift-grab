import 'package:gift_grab/data/services/storage/storage_service.dart';

class GamesPlayedStorage extends BaseStorageService<int> {
  @override
  String get collection => 'game_info';

  @override
  String get key => 'player_stats';

  @override
  String get valueKey => 'games_played';

  @override
  int get defaultValue => 0;

  @override
  int parseValue(dynamic json) => json[valueKey];

  @override
  Map<String, dynamic> serializeValue(int value) => {valueKey: value};
}
