import 'package:freezed_annotation/freezed_annotation.dart';

part 'leaderboard_record_model.freezed.dart';
part 'leaderboard_record_model.g.dart';

/// {@template leaderboard_record_model}
/// LeaderboardRecordModel description
/// {@endtemplate}
@freezed
class LeaderboardRecordModel with _$LeaderboardRecordModel {
  /// {@macro leaderboard_record_model}
  const factory LeaderboardRecordModel({
    @JsonKey(name: 'leaderboard_id') required String leaderboardId,
    @JsonKey(name: 'owner_id') required String ownerId,
    required String username,
    required int score,
    @JsonKey(name: 'num_score') required int numScore,
    @JsonKey(name: 'create_time') required String createTime,
    @JsonKey(name: 'update_time') required String updateTime,
    @JsonKey(name: 'expiry_time') required String expiryTime,
    required String rank,
    @JsonKey(name: 'max_num_score') required int maxNumScore,
  }) = _LeaderboardRecordModel;

  /// Creates a LeaderboardRecordModel from Json map
  factory LeaderboardRecordModel.fromJson(Map<String, dynamic> data) =>
      _$LeaderboardRecordModelFromJson(data);
}
