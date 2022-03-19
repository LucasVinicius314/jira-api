// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_4.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      email: json['email'] as String,
      username: json['username'] as String,
      id: json['id'] as int,
      updatedAt: json['updatedAt'],
      createdAt: json['createdAt'],
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'email': instance.email,
      'username': instance.username,
      'id': instance.id,
      'updatedAt': instance.updatedAt,
      'createdAt': instance.createdAt,
    };
