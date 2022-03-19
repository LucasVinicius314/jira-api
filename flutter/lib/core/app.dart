import 'package:flutter/material.dart';
import 'package:jira_api/modules/login_page.dart';
import 'package:jira_api/modules/main_page.dart';
import 'package:jira_api/modules/splash_page.dart';

final buttonStyle = ButtonStyle(
  padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
);

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jira API',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        textButtonTheme: TextButtonThemeData(style: buttonStyle),
        elevatedButtonTheme: ElevatedButtonThemeData(style: buttonStyle),
        outlinedButtonTheme: OutlinedButtonThemeData(style: buttonStyle),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange),
      ),
      routes: {
        SplashPage.route: (context) => const SplashPage(),
        LoginPage.route: (context) => const LoginPage(),
        MainPage.route: (context) => const MainPage(),
      },
    );
  }
}
