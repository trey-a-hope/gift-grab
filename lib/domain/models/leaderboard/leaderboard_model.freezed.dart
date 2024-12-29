// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'leaderboard_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LeaderboardModel _$LeaderboardModelFromJson(Map<String, dynamic> json) {
  return _LeaderboardModel.fromJson(json);
}

/// @nodoc
mixin _$LeaderboardModel {
  List<LeaderboardRecordModel> get records =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'next_cursor')
  String get nextCursor => throw _privateConstructorUsedError;

  /// Serializes this LeaderboardModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LeaderboardModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LeaderboardModelCopyWith<LeaderboardModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LeaderboardModelCopyWith<$Res> {
  factory $LeaderboardModelCopyWith(
          LeaderboardModel value, $Res Function(LeaderboardModel) then) =
      _$LeaderboardModelCopyWithImpl<$Res, LeaderboardModel>;
  @useResult
  $Res call(
      {List<LeaderboardRecordModel> records,
      @JsonKey(name: 'next_cursor') String nextCursor});
}

/// @nodoc
class _$LeaderboardModelCopyWithImpl<$Res, $Val extends LeaderboardModel>
    implements $LeaderboardModelCopyWith<$Res> {
  _$LeaderboardModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LeaderboardModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? records = null,
    Object? nextCursor = null,
  }) {
    return _then(_value.copyWith(
      records: null == records
          ? _value.records
          : records // ignore: cast_nullable_to_non_nullable
              as List<LeaderboardRecordModel>,
      nextCursor: null == nextCursor
          ? _value.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LeaderboardModelImplCopyWith<$Res>
    implements $LeaderboardModelCopyWith<$Res> {
  factory _$$LeaderboardModelImplCopyWith(_$LeaderboardModelImpl value,
          $Res Function(_$LeaderboardModelImpl) then) =
      __$$LeaderboardModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<LeaderboardRecordModel> records,
      @JsonKey(name: 'next_cursor') String nextCursor});
}

/// @nodoc
class __$$LeaderboardModelImplCopyWithImpl<$Res>
    extends _$LeaderboardModelCopyWithImpl<$Res, _$LeaderboardModelImpl>
    implements _$$LeaderboardModelImplCopyWith<$Res> {
  __$$LeaderboardModelImplCopyWithImpl(_$LeaderboardModelImpl _value,
      $Res Function(_$LeaderboardModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of LeaderboardModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? records = null,
    Object? nextCursor = null,
  }) {
    return _then(_$LeaderboardModelImpl(
      records: null == records
          ? _value._records
          : records // ignore: cast_nullable_to_non_nullable
              as List<LeaderboardRecordModel>,
      nextCursor: null == nextCursor
          ? _value.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LeaderboardModelImpl implements _LeaderboardModel {
  const _$LeaderboardModelImpl(
      {required final List<LeaderboardRecordModel> records,
      @JsonKey(name: 'next_cursor') required this.nextCursor})
      : _records = records;

  factory _$LeaderboardModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LeaderboardModelImplFromJson(json);

  final List<LeaderboardRecordModel> _records;
  @override
  List<LeaderboardRecordModel> get records {
    if (_records is EqualUnmodifiableListView) return _records;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_records);
  }

  @override
  @JsonKey(name: 'next_cursor')
  final String nextCursor;

  @override
  String toString() {
    return 'LeaderboardModel(records: $records, nextCursor: $nextCursor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeaderboardModelImpl &&
            const DeepCollectionEquality().equals(other._records, _records) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_records), nextCursor);

  /// Create a copy of LeaderboardModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LeaderboardModelImplCopyWith<_$LeaderboardModelImpl> get copyWith =>
      __$$LeaderboardModelImplCopyWithImpl<_$LeaderboardModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LeaderboardModelImplToJson(
      this,
    );
  }
}

abstract class _LeaderboardModel implements LeaderboardModel {
  const factory _LeaderboardModel(
          {required final List<LeaderboardRecordModel> records,
          @JsonKey(name: 'next_cursor') required final String nextCursor}) =
      _$LeaderboardModelImpl;

  factory _LeaderboardModel.fromJson(Map<String, dynamic> json) =
      _$LeaderboardModelImpl.fromJson;

  @override
  List<LeaderboardRecordModel> get records;
  @override
  @JsonKey(name: 'next_cursor')
  String get nextCursor;

  /// Create a copy of LeaderboardModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LeaderboardModelImplCopyWith<_$LeaderboardModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
