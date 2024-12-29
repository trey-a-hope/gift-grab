// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AccountModelImpl _$$AccountModelImplFromJson(Map<String, dynamic> json) =>
    _$AccountModelImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      createTime: json['create_time'] as String,
      updateTime: json['update_time'] as String?,
    );

Map<String, dynamic> _$$AccountModelImplToJson(_$AccountModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'create_time': instance.createTime,
      'update_time': instance.updateTime,
    };
