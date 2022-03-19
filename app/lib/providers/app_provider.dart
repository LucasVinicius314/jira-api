import 'package:flutter/material.dart';
import 'package:jira_api/models/user_4.dart';
import 'package:provider/provider.dart';

class AppProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  set user(User? user) {
    _user = user;

    notifyListeners();
  }

  static AppProvider of(BuildContext context) {
    return Provider.of<AppProvider>(context, listen: false);
  }

  static AppProvider listen(BuildContext context) {
    return Provider.of<AppProvider>(context, listen: true);
  }
}
