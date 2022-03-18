import 'package:flutter/material.dart';
import 'package:jira_api/modules/main_page.dart';
import 'package:jira_api/modules/splash_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jira API',
      color: Colors.orange,
      debugShowCheckedModeBanner: false,
      routes: {
        MainPage.route: (context) => const MainPage(),
        SplashPage.route: (context) => const SplashPage(),
      },
    );
  }
}
