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
      project: json['project'],
      comment: json['comment'],
      issueLinks: json['issueLinks'],
      workLog: json['workLog'],
      updated: json['updated'],
      timetracking: json['timetracking'],
      summary: json['summary'] as String?,
      description: json['description'] == null
          ? null
          : Description.fromJson(json['description'] as Map<String, dynamic>),
      issuetype: json['issuetype'] == null
          ? null
          : IssueType.fromJson(json['issuetype'] as Map<String, dynamic>),
      status: json['status'] == null
          ? null
          : Status.fromJson(json['status'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FieldsToJson(Fields instance) => <String, dynamic>{
      'watcher': instance.watcher,
      'attachment': instance.attachment,
      'project': instance.project,
      'comment': instance.comment,
      'issueLinks': instance.issueLinks,
      'workLog': instance.workLog,
      'updated': instance.updated,
      'timetracking': instance.timetracking,
      'summary': instance.summary,
      'description': instance.description?.toJson(),
      'issuetype': instance.issuetype?.toJson(),
      'status': instance.status?.toJson(),
    };

Search _$SearchFromJson(Map<String, dynamic> json) => Search(
      expand: json['expand'] as String?,
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

Status _$StatusFromJson(Map<String, dynamic> json) => Status(
      self: json['self'] as String,
      description: json['description'] as String,
      iconUrl: json['iconUrl'] as String,
      name: json['name'] as String,
      id: json['id'] as String,
      statusCategory: StatusCategory.fromJson(
          json['statusCategory'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StatusToJson(Status instance) => <String, dynamic>{
      'self': instance.self,
      'description': instance.description,
      'iconUrl': instance.iconUrl,
      'name': instance.name,
      'id': instance.id,
      'statusCategory': instance.statusCategory.toJson(),
    };

StatusCategory _$StatusCategoryFromJson(Map<String, dynamic> json) =>
    StatusCategory(
      self: json['self'] as String,
      id: json['id'] as int,
      key: json['key'] as String,
      colorName: json['colorName'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$StatusCategoryToJson(StatusCategory instance) =>
    <String, dynamic>{
      'self': instance.self,
      'id': instance.id,
      'key': instance.key,
      'colorName': instance.colorName,
      'name': instance.name,
    };

IssueType _$IssueTypeFromJson(Map<String, dynamic> json) => IssueType(
      self: json['self'] as String,
      id: json['id'] as String,
      description: json['description'] as String,
      iconUrl: json['iconUrl'] as String,
      name: json['name'] as String,
      subtask: json['subtask'] as bool,
      avatarId: json['avatarId'] as int?,
      hierarchyLevel: json['hierarchyLevel'] as int?,
    );

Map<String, dynamic> _$IssueTypeToJson(IssueType instance) => <String, dynamic>{
      'self': instance.self,
      'id': instance.id,
      'description': instance.description,
      'iconUrl': instance.iconUrl,
      'name': instance.name,
      'subtask': instance.subtask,
      'avatarId': instance.avatarId,
      'hierarchyLevel': instance.hierarchyLevel,
    };
