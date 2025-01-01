// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AccountModelImpl _$$AccountModelImplFromJson(Map<String, dynamic> json) =>
    _$AccountModelImpl(
      email: json['email'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AccountModelImplToJson(_$AccountModelImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'user': instance.user,
    };
