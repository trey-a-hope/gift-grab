import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gift_grab/domain/models/leaderboard_record/leaderboard_record_model.dart';

part 'leaderboard_model.freezed.dart';
part 'leaderboard_model.g.dart';

/// {@template leaderboard_model}
/// LeaderboardModel description
/// {@endtemplate}
@freezed
class LeaderboardModel with _$LeaderboardModel {
  /// {@macro leaderboard_model}
  const factory LeaderboardModel({
    required List<LeaderboardRecordModel> records,
    @JsonKey(name: 'next_cursor') required String nextCursor,
  }) = _LeaderboardModel;

  /// Creates a LeaderboardModel from Json map
  factory LeaderboardModel.fromJson(Map<String, dynamic> data) =>
      _$LeaderboardModelFromJson(data);
}
