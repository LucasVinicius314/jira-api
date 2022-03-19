// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Issue _$IssueFromJson(Map<String, dynamic> json) => Issue(
      expand: json['expand'] as String,
      id: json['id'] as String,
      self: json['self'] as String,
      key: json['key'] as String,
      fields: Fields.fromJson(json['fields'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$IssueToJson(Issue instance) => <String, dynamic>{
      'expand': instance.expand,
      'id': instance.id,
      'self': instance.self,
      'key': instance.key,
      'fields': instance.fields.toJson(),
    };

Fields _$FieldsFromJson(Map<String, dynamic> json) => Fields(
      watcher: json['watcher'],
      attachment: json['attachment'],
      description: json['description'] == null
          ? null
          : Description.fromJson(json['description'] as Map<String, dynamic>),
      project: json['project'],
      comment: json['comment'],
      issueLinks: json['issueLinks'],
      workLog: json['workLog'],
      updated: json['updated'],
      timetracking: json['timetracking'],
      summary: json['summary'] as String?,
    );

Map<String, dynamic> _$FieldsToJson(Fields instance) => <String, dynamic>{
      'watcher': instance.watcher,
      'attachment': instance.attachment,
      'description': instance.description?.toJson(),
      'project': instance.project,
      'comment': instance.comment,
      'issueLinks': instance.issueLinks,
      'workLog': instance.workLog,
      'updated': instance.updated,
      'timetracking': instance.timetracking,
      'summary': instance.summary,
    };

Search _$SearchFromJson(Map<String, dynamic> json) => Search(
      expand: json['expand'] as String,
      startAt: json['startAt'] as int,
      maxResults: json['maxResults'] as int,
      total: json['total'] as int,
      issues: (json['issues'] as List<dynamic>)
          .map((e) => Issue.fromJson(e as Map<String, dynamic>))
          .toList(),
      warningMessages: (json['warningMessages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$SearchToJson(Search instance) => <String, dynamic>{
      'expand': instance.expand,
      'startAt': instance.startAt,
      'maxResults': instance.maxResults,
      'total': instance.total,
      'issues': instance.issues.map((e) => e.toJson()).toList(),
      'warningMessages': instance.warningMessages,
    };

Description _$DescriptionFromJson(Map<String, dynamic> json) => Description(
      type: json['type'] as String,
      version: json['version'] as int?,
      text: json['text'] as String?,
      content: (json['content'] as List<dynamic>?)
          ?.map((e) => Description.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DescriptionToJson(Description instance) =>
    <String, dynamic>{
      'type': instance.type,
      'version': instance.version,
      'text': instance.text,
      'content': instance.content?.map((e) => e.toJson()).toList(),
    };
