import 'package:jira_api/utils/services/networking.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_4.g.dart';

@JsonSerializable(fieldRename: FieldRename.none, explicitToJson: true)
class User {
  final String email;
  final String username;

  final int id;
  final dynamic updatedAt;
  final dynamic createdAt;

  User({
    required this.email,
    required this.username,
    required this.id,
    required this.updatedAt,
    required this.createdAt,
  });

  static Future<User> login({
    required String email,
    required String password,
  }) async {
    return User.fromJson(await Api.post('auth/login', {
      'email': email,
      'password': password,
    }));
  }

  static Future<User> auth() async {
    return User.fromJson(await Api.get('auth/auth'));
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
