import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jira_api/core/app.dart';

void main() async {
  await dotenv.load(fileName: 'env.env');

  runApp(const App());
}
