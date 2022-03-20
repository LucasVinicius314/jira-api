import 'package:flutter/material.dart';
import 'package:jira_api/models/project.dart';
import 'package:jira_api/modules/splash_page.dart';
import 'package:jira_api/providers/app_provider.dart';
import 'package:jira_api/utils/services/shared_preferences.dart';
import 'package:jira_api/widgets/issues_widget.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  static const route = 'main';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Future<void> _newIssue() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: const Text('Work in progress.'),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }

  Future<void> _logout() async {
    await SharedPreferences.setAuthorization(null);

    await Navigator.of(context).pushReplacementNamed(SplashPage.route);
  }

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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _newIssue,
        icon: const Icon(Icons.add),
        label: const Text('NEW ISSUE'),
      ),
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
            ListTile(
              onTap: _logout,
              title: const Text('Logout'),
            ),
          ],
        ),
      ),
      body: FutureBuilder<Project>(
        future: Project.project(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          if (snapshot.connectionState == ConnectionState.done) {
            final project = snapshot.data;

            if (project == null) {
              return const Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'Project not found.',
                  textAlign: TextAlign.center,
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.only(bottom: 128),
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                    left: 16,
                    right: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        project.name,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Text(
                        project.key,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                ),
                IssuesWidget(project: project),
              ],
            );
          }

          return const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
