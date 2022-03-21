import 'package:flutter/material.dart';
import 'package:sure_project_manager/modules/login_page.dart';
import 'package:sure_project_manager/modules/main_page.dart';
import 'package:sure_project_manager/modules/splash_page.dart';
import 'package:sure_project_manager/providers/app_provider.dart';
import 'package:provider/provider.dart';

final buttonStyle = ButtonStyle(
  padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
);

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: MaterialApp(
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
      ),
    );
  }
}
