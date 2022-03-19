import 'package:jira_api/utils/services/networking.dart';
import 'package:json_annotation/json_annotation.dart';

part 'issue.g.dart';

@JsonSerializable(fieldRename: FieldRename.none, explicitToJson: true)
class Issue {
  final String expand;
  final String id;
  final String self;
  final String key;
  final Fields fields;

  Issue({
    required this.expand,
    required this.id,
    required this.self,
    required this.key,
    required this.fields,
  });

  static Future<Search> search() async {
    return Search.fromJson(await Api.get('jira/search', {
      'fields': 'summary,description',
    }));
  }

  factory Issue.fromJson(Map<String, dynamic> json) => _$IssueFromJson(json);

  Map<String, dynamic> toJson() => _$IssueToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none, explicitToJson: true)
class Fields {
  final dynamic watcher;
  final dynamic attachment;
  // final dynamic sub-tasks;
  final Description? description;
  final dynamic project;
  final dynamic comment;
  final dynamic issueLinks;
  final dynamic workLog;
  final dynamic updated;
  final dynamic timetracking;
  final String? summary;

  Fields({
    required this.watcher,
    required this.attachment,
    // required this.sub-tasks,
    required this.description,
    required this.project,
    required this.comment,
    required this.issueLinks,
    required this.workLog,
    required this.updated,
    required this.timetracking,
    required this.summary,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => _$FieldsFromJson(json);

  Map<String, dynamic> toJson() => _$FieldsToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none, explicitToJson: true)
class Search {
  final String expand;
  final int startAt;
  final int maxResults;
  final int total;
  final List<Issue> issues;
  final List<String>? warningMessages;

  Search({
    required this.expand,
    required this.startAt,
    required this.maxResults,
    required this.total,
    required this.issues,
    required this.warningMessages,
  });

  factory Search.fromJson(Map<String, dynamic> json) => _$SearchFromJson(json);

  Map<String, dynamic> toJson() => _$SearchToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none, explicitToJson: true)
class Description {
  final String type;
  final int? version;
  final String? text;
  final List<Description>? content;

  String compute() {
    if (text != null) return text ?? '';

    if (content != null) {
      return (content ?? []).map((e) => e.compute()).join('');
    }

    return '';
  }

  Description({
    required this.type,
    required this.version,
    required this.text,
    required this.content,
  });

  factory Description.fromJson(Map<String, dynamic> json) =>
      _$DescriptionFromJson(json);

  Map<String, dynamic> toJson() => _$DescriptionToJson(this);
}
