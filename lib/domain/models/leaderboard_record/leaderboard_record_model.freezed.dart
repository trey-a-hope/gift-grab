// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'leaderboard_record_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LeaderboardRecordModel _$LeaderboardRecordModelFromJson(
    Map<String, dynamic> json) {
  return _LeaderboardRecordModel.fromJson(json);
}

/// @nodoc
mixin _$LeaderboardRecordModel {
  @JsonKey(name: 'leaderboard_id')
  String get leaderboardId => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner_id')
  String get ownerId => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  int get score => throw _privateConstructorUsedError;
  @JsonKey(name: 'num_score')
  int get numScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'create_time')
  String get createTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'update_time')
  String get updateTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'expiry_time')
  String get expiryTime => throw _privateConstructorUsedError;
  String get rank => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_num_score')
  int get maxNumScore => throw _privateConstructorUsedError;

  /// Serializes this LeaderboardRecordModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LeaderboardRecordModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LeaderboardRecordModelCopyWith<LeaderboardRecordModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LeaderboardRecordModelCopyWith<$Res> {
  factory $LeaderboardRecordModelCopyWith(LeaderboardRecordModel value,
          $Res Function(LeaderboardRecordModel) then) =
      _$LeaderboardRecordModelCopyWithImpl<$Res, LeaderboardRecordModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'leaderboard_id') String leaderboardId,
      @JsonKey(name: 'owner_id') String ownerId,
      String username,
      int score,
      @JsonKey(name: 'num_score') int numScore,
      @JsonKey(name: 'create_time') String createTime,
      @JsonKey(name: 'update_time') String updateTime,
      @JsonKey(name: 'expiry_time') String expiryTime,
      String rank,
      @JsonKey(name: 'max_num_score') int maxNumScore});
}

/// @nodoc
class _$LeaderboardRecordModelCopyWithImpl<$Res,
        $Val extends LeaderboardRecordModel>
    implements $LeaderboardRecordModelCopyWith<$Res> {
  _$LeaderboardRecordModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LeaderboardRecordModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? leaderboardId = null,
    Object? ownerId = null,
    Object? username = null,
    Object? score = null,
    Object? numScore = null,
    Object? createTime = null,
    Object? updateTime = null,
    Object? expiryTime = null,
    Object? rank = null,
    Object? maxNumScore = null,
  }) {
    return _then(_value.copyWith(
      leaderboardId: null == leaderboardId
          ? _value.leaderboardId
          : leaderboardId // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
      numScore: null == numScore
          ? _value.numScore
          : numScore // ignore: cast_nullable_to_non_nullable
              as int,
      createTime: null == createTime
          ? _value.createTime
          : createTime // ignore: cast_nullable_to_non_nullable
              as String,
      updateTime: null == updateTime
          ? _value.updateTime
          : updateTime // ignore: cast_nullable_to_non_nullable
              as String,
      expiryTime: null == expiryTime
          ? _value.expiryTime
          : expiryTime // ignore: cast_nullable_to_non_nullable
              as String,
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as String,
      maxNumScore: null == maxNumScore
          ? _value.maxNumScore
          : maxNumScore // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LeaderboardRecordModelImplCopyWith<$Res>
    implements $LeaderboardRecordModelCopyWith<$Res> {
  factory _$$LeaderboardRecordModelImplCopyWith(
          _$LeaderboardRecordModelImpl value,
          $Res Function(_$LeaderboardRecordModelImpl) then) =
      __$$LeaderboardRecordModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'leaderboard_id') String leaderboardId,
      @JsonKey(name: 'owner_id') String ownerId,
      String username,
      int score,
      @JsonKey(name: 'num_score') int numScore,
      @JsonKey(name: 'create_time') String createTime,
      @JsonKey(name: 'update_time') String updateTime,
      @JsonKey(name: 'expiry_time') String expiryTime,
      String rank,
      @JsonKey(name: 'max_num_score') int maxNumScore});
}

/// @nodoc
class __$$LeaderboardRecordModelImplCopyWithImpl<$Res>
    extends _$LeaderboardRecordModelCopyWithImpl<$Res,
        _$LeaderboardRecordModelImpl>
    implements _$$LeaderboardRecordModelImplCopyWith<$Res> {
  __$$LeaderboardRecordModelImplCopyWithImpl(
      _$LeaderboardRecordModelImpl _value,
      $Res Function(_$LeaderboardRecordModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of LeaderboardRecordModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? leaderboardId = null,
    Object? ownerId = null,
    Object? username = null,
    Object? score = null,
    Object? numScore = null,
    Object? createTime = null,
    Object? updateTime = null,
    Object? expiryTime = null,
    Object? rank = null,
    Object? maxNumScore = null,
  }) {
    return _then(_$LeaderboardRecordModelImpl(
      leaderboardId: null == leaderboardId
          ? _value.leaderboardId
          : leaderboardId // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
      numScore: null == numScore
          ? _value.numScore
          : numScore // ignore: cast_nullable_to_non_nullable
              as int,
      createTime: null == createTime
          ? _value.createTime
          : createTime // ignore: cast_nullable_to_non_nullable
              as String,
      updateTime: null == updateTime
          ? _value.updateTime
          : updateTime // ignore: cast_nullable_to_non_nullable
              as String,
      expiryTime: null == expiryTime
          ? _value.expiryTime
          : expiryTime // ignore: cast_nullable_to_non_nullable
              as String,
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as String,
      maxNumScore: null == maxNumScore
          ? _value.maxNumScore
          : maxNumScore // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LeaderboardRecordModelImpl implements _LeaderboardRecordModel {
  const _$LeaderboardRecordModelImpl(
      {@JsonKey(name: 'leaderboard_id') required this.leaderboardId,
      @JsonKey(name: 'owner_id') required this.ownerId,
      required this.username,
      required this.score,
      @JsonKey(name: 'num_score') required this.numScore,
      @JsonKey(name: 'create_time') required this.createTime,
      @JsonKey(name: 'update_time') required this.updateTime,
      @JsonKey(name: 'expiry_time') required this.expiryTime,
      required this.rank,
      @JsonKey(name: 'max_num_score') required this.maxNumScore});

  factory _$LeaderboardRecordModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LeaderboardRecordModelImplFromJson(json);

  @override
  @JsonKey(name: 'leaderboard_id')
  final String leaderboardId;
  @override
  @JsonKey(name: 'owner_id')
  final String ownerId;
  @override
  final String username;
  @override
  final int score;
  @override
  @JsonKey(name: 'num_score')
  final int numScore;
  @override
  @JsonKey(name: 'create_time')
  final String createTime;
  @override
  @JsonKey(name: 'update_time')
  final String updateTime;
  @override
  @JsonKey(name: 'expiry_time')
  final String expiryTime;
  @override
  final String rank;
  @override
  @JsonKey(name: 'max_num_score')
  final int maxNumScore;

  @override
  String toString() {
    return 'LeaderboardRecordModel(leaderboardId: $leaderboardId, ownerId: $ownerId, username: $username, score: $score, numScore: $numScore, createTime: $createTime, updateTime: $updateTime, expiryTime: $expiryTime, rank: $rank, maxNumScore: $maxNumScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeaderboardRecordModelImpl &&
            (identical(other.leaderboardId, leaderboardId) ||
                other.leaderboardId == leaderboardId) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.numScore, numScore) ||
                other.numScore == numScore) &&
            (identical(other.createTime, createTime) ||
                other.createTime == createTime) &&
            (identical(other.updateTime, updateTime) ||
                other.updateTime == updateTime) &&
            (identical(other.expiryTime, expiryTime) ||
                other.expiryTime == expiryTime) &&
            (identical(other.rank, rank) || other.rank == rank) &&
            (identical(other.maxNumScore, maxNumScore) ||
                other.maxNumScore == maxNumScore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, leaderboardId, ownerId, username,
      score, numScore, createTime, updateTime, expiryTime, rank, maxNumScore);

  /// Create a copy of LeaderboardRecordModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LeaderboardRecordModelImplCopyWith<_$LeaderboardRecordModelImpl>
      get copyWith => __$$LeaderboardRecordModelImplCopyWithImpl<
          _$LeaderboardRecordModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LeaderboardRecordModelImplToJson(
      this,
    );
  }
}

abstract class _LeaderboardRecordModel implements LeaderboardRecordModel {
  const factory _LeaderboardRecordModel(
          {@JsonKey(name: 'leaderboard_id') required final String leaderboardId,
          @JsonKey(name: 'owner_id') required final String ownerId,
          required final String username,
          required final int score,
          @JsonKey(name: 'num_score') required final int numScore,
          @JsonKey(name: 'create_time') required final String createTime,
          @JsonKey(name: 'update_time') required final String updateTime,
          @JsonKey(name: 'expiry_time') required final String expiryTime,
          required final String rank,
          @JsonKey(name: 'max_num_score') required final int maxNumScore}) =
      _$LeaderboardRecordModelImpl;

  factory _LeaderboardRecordModel.fromJson(Map<String, dynamic> json) =
      _$LeaderboardRecordModelImpl.fromJson;

  @override
  @JsonKey(name: 'leaderboard_id')
  String get leaderboardId;
  @override
  @JsonKey(name: 'owner_id')
  String get ownerId;
  @override
  String get username;
  @override
  int get score;
  @override
  @JsonKey(name: 'num_score')
  int get numScore;
  @override
  @JsonKey(name: 'create_time')
  String get createTime;
  @override
  @JsonKey(name: 'update_time')
  String get updateTime;
  @override
  @JsonKey(name: 'expiry_time')
  String get expiryTime;
  @override
  String get rank;
  @override
  @JsonKey(name: 'max_num_score')
  int get maxNumScore;

  /// Create a copy of LeaderboardRecordModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LeaderboardRecordModelImplCopyWith<_$LeaderboardRecordModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
