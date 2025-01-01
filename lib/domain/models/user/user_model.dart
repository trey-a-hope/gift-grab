import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// {@template user_model}
/// UserModel description
/// {@endtemplate}
@freezed
class UserModel with _$UserModel {
  /// {@macro user_model}
  const factory UserModel({
    required String id,
    required String username,
    // @JsonKey(name: 'create_time') required String createTime,
    // @JsonKey(name: 'update_time') required String? updateTime,
  }) = _UserModel;

  /// Creates a UserModel from Json map
  factory UserModel.fromJson(Map<String, dynamic> data) =>
      _$UserModelFromJson(data);
}

//flutter pub run build_runner build --delete-conflicting-outputs
