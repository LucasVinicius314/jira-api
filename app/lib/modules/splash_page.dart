import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jira_api/models/user_4.dart';
import 'package:jira_api/modules/login_page.dart';
import 'package:jira_api/modules/main_page.dart';
import 'package:jira_api/providers/app_provider.dart';
import 'package:jira_api/utils/services/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  static const route = '/';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () async {
      try {
        final authorization = await SharedPreferences.authorization;

        if (authorization != null) {
          final user = await User.auth();

          final provider = AppProvider.of(context);

          provider.user = user;

          await Navigator.of(context).pushReplacementNamed(MainPage.route);
        }

        await Navigator.of(context).pushReplacementNamed(LoginPage.route);
      } catch (e) {
        if (kDebugMode) rethrow;

        await Navigator.of(context).pushReplacementNamed(LoginPage.route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
