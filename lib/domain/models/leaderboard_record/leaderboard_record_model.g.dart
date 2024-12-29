// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LeaderboardRecordModelImpl _$$LeaderboardRecordModelImplFromJson(
        Map<String, dynamic> json) =>
    _$LeaderboardRecordModelImpl(
      leaderboardId: json['leaderboard_id'] as String,
      ownerId: json['owner_id'] as String,
      username: json['username'] as String,
      score: (json['score'] as num).toInt(),
      numScore: (json['num_score'] as num).toInt(),
      createTime: json['create_time'] as String,
      updateTime: json['update_time'] as String,
      expiryTime: json['expiry_time'] as String,
      rank: json['rank'] as String,
      maxNumScore: (json['max_num_score'] as num).toInt(),
    );

Map<String, dynamic> _$$LeaderboardRecordModelImplToJson(
        _$LeaderboardRecordModelImpl instance) =>
    <String, dynamic>{
      'leaderboard_id': instance.leaderboardId,
      'owner_id': instance.ownerId,
      'username': instance.username,
      'score': instance.score,
      'num_score': instance.numScore,
      'create_time': instance.createTime,
      'update_time': instance.updateTime,
      'expiry_time': instance.expiryTime,
      'rank': instance.rank,
      'max_num_score': instance.maxNumScore,
    };
