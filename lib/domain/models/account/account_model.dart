import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gift_grab/domain/models/user/user_model.dart';

part 'account_model.freezed.dart';
part 'account_model.g.dart';

/// {@template account_model}
/// AccountModel description
/// {@endtemplate}
@freezed
class AccountModel with _$AccountModel {
  /// {@macro account_model}
  const factory AccountModel({
    required String email,
    required UserModel user,
  }) = _AccountModel;

  /// Creates a AccountModel from Json map
  factory AccountModel.fromJson(Map<String, dynamic> data) =>
      _$AccountModelFromJson(data);
}

//flutter pub run build_runner build --delete-conflicting-outputs
