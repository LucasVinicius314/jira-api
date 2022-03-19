// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Project _$ProjectFromJson(Map<String, dynamic> json) => Project(
      self: json['self'] as String,
      id: json['id'] as String,
      key: json['key'] as String,
      name: json['name'] as String,
      avatarUrls: json['avatarUrls'],
      projectCategory: json['projectCategory'],
      simplified: json['simplified'] as bool,
      style: json['style'] as String,
      insight: json['insight'],
    );

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
      'self': instance.self,
      'id': instance.id,
      'key': instance.key,
      'name': instance.name,
      'avatarUrls': instance.avatarUrls,
      'projectCategory': instance.projectCategory,
      'simplified': instance.simplified,
      'style': instance.style,
      'insight': instance.insight,
    };
