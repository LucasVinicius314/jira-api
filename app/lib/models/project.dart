import 'package:jira_api/utils/services/networking.dart';
import 'package:json_annotation/json_annotation.dart';

part 'project.g.dart';

@JsonSerializable(fieldRename: FieldRename.none, explicitToJson: true)
class Project {
  final String self;
  final String id;
  final String key;
  final String name;
  final dynamic avatarUrls;
  final dynamic projectCategory;
  final bool simplified;
  final String style;
  final dynamic insight;

  Project({
    required this.self,
    required this.id,
    required this.key,
    required this.name,
    required this.avatarUrls,
    required this.projectCategory,
    required this.simplified,
    required this.style,
    required this.insight,
  });

  static Future<Project> project() async {
    final req = await Api.get('jira/project');

    return Project.fromJson(req);
  }

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
