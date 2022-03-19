import 'package:flutter/material.dart';
import 'package:jira_api/models/issue.dart';
import 'package:jira_api/models/project.dart';
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
  Future<void> _newIssue() async {
    // TODO: fix
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
        label: const Text('New issue'),
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
          ],
        ),
      ),
      body: FutureBuilder<Iterable<Project>>(
        future: Project.project(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          if (snapshot.connectionState == ConnectionState.done) {
            final projects = snapshot.data ?? [];

            if (projects.length != 1) {
              return const Text('More than one available project.');
            }

            final project = projects.first;

            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    project.name,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Issues',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                FutureBuilder<Search>(
                  future: Issue.search(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      final issues = snapshot.data?.issues ?? [];

                      if (issues.isEmpty) {
                        return const Text('No issues found.');
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        itemCount: issues.length,
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          mainAxisExtent: 180,
                          maxCrossAxisExtent: 300,
                        ),
                        itemBuilder: (context, index) {
                          final issue = issues.elementAt(index);

                          return Card(
                            margin: EdgeInsets.zero,
                            clipBehavior: Clip.antiAlias,
                            child: InkWell(
                              onTap: () {
                                // TODO: fix
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text(
                                            issue.fields.summary ?? '',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                          Text(
                                            issue.fields.description
                                                    ?.compute() ??
                                                '',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Divider(height: 0),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    child: Text(
                                      issue.key,
                                      textAlign: TextAlign.end,
                                      style:
                                          Theme.of(context).textTheme.caption,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }

                    return const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                )
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
