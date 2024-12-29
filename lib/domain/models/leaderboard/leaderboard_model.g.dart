// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LeaderboardModelImpl _$$LeaderboardModelImplFromJson(
        Map<String, dynamic> json) =>
    _$LeaderboardModelImpl(
      records: (json['records'] as List<dynamic>)
          .map(
              (e) => LeaderboardRecordModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['next_cursor'] as String,
    );

Map<String, dynamic> _$$LeaderboardModelImplToJson(
        _$LeaderboardModelImpl instance) =>
    <String, dynamic>{
      'records': instance.records,
      'next_cursor': instance.nextCursor,
    };
