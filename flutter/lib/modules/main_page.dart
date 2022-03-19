import 'package:flutter/material.dart';
import 'package:jira_api/modules/splash_page.dart';
import 'package:jira_api/providers/app_provider.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  static const route = 'main';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      final provider = AppProvider.of(context);

      final user = provider.user;

      if (user == null) {
        await Navigator.of(context).pushReplacementNamed(SplashPage.route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jira API')),
      drawer: Drawer(
        child: ListView(
          children: [
            Consumer<AppProvider>(
              builder: (context, value, child) {
                final user = value.user;

                if (user == null) return Container();

                return DrawerHeader(
                  child: ListTile(
                    title: Text(user.username),
                    subtitle: Text(user.email),
                    contentPadding: EdgeInsets.zero,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
