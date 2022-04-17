import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sure_project_manager/models/issue.dart';
import 'package:sure_project_manager/models/project.dart';
import 'package:sure_project_manager/utils/services/pdf.dart';
import 'package:sure_project_manager/widgets/issue_dialog_widget.dart';

class IssuesWidget extends StatefulWidget {
  const IssuesWidget({Key? key, required this.project}) : super(key: key);

  final Project project;

  @override
  State<IssuesWidget> createState() => _IssuesWidgetState();
}

class _IssuesWidgetState extends State<IssuesWidget> {
  Future<Search>? _searchFuture;

  Future<void> _export() async {
    final search = await _searchFuture;

    final issues = search?.issues ?? [];

    try {
      await exportIssues(issues: issues);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: const Text('Data exported. Check your downloads folder.'),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {},
          ),
        ),
      );
    } catch (e) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Warning'),
            content: const Text(
              'Something went wrong when exporting - make sure you\'ve configured your export settings correctly.',
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(primary: Colors.green),
                child: const Text('OK'),
                onPressed: () async {
                  await Navigator.of(context).maybePop();
                },
              ),
            ],
          );
        },
      );

      if (kDebugMode) rethrow;
    }
  }

  void _fetchSearch() async {
    setState(() {
      _searchFuture = Issue.search();
    });
  }

  @override
  void initState() {
    super.initState();

    _fetchSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          title: const Text(
            'Issues',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Wrap(
            children: [
              FutureBuilder(
                future: _searchFuture,
                builder: (context, snapshot) {
                  final waiting =
                      snapshot.connectionState == ConnectionState.waiting;

                  return IconButton(
                    tooltip: 'Refresh issues',
                    icon: const Icon(Icons.refresh),
                    onPressed: waiting ? null : _fetchSearch,
                  );
                },
              ),
              const SizedBox(width: 16),
              FutureBuilder<Search>(
                future: _searchFuture,
                builder: (context, snapshot) {
                  final waiting =
                      snapshot.connectionState == ConnectionState.waiting;

                  final disabled = snapshot.data?.issues.isEmpty ?? true;

                  return IconButton(
                    tooltip: 'Export issues',
                    icon: const Icon(Icons.download),
                    onPressed: waiting || disabled ? null : _export,
                  );
                },
              ),
            ],
          ),
        ),
        FutureBuilder<Search>(
          future: _searchFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  snapshot.error.toString(),
                  textAlign: TextAlign.center,
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.done) {
              final issues = snapshot.data?.issues ?? [];

              if (issues.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    'No issues found.',
                    textAlign: TextAlign.center,
                  ),
                );
              }

              return GridView.builder(
                shrinkWrap: true,
                itemCount: issues.length,
                padding: const EdgeInsets.all(16),
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  mainAxisExtent: 180,
                  maxCrossAxisExtent: 300,
                ),
                itemBuilder: (context, index) {
                  final issue = issues.elementAt(index);

                  Future<void> onTap() async {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return IssueDialogWidget(
                          issue: issue,
                          project: widget.project,
                        );
                      },
                    );
                  }

                  return Card(
                    margin: EdgeInsets.zero,
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: onTap,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Wrap(
                                clipBehavior: Clip.antiAlias,
                                children: [
                                  Column(
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
                                        issue.fields.description?.compute() ??
                                            '',
                                      ),
                                    ],
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
                            child: Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Builder(
                                  builder: (context) {
                                    final statusCategory =
                                        issue.fields.status?.statusCategory;

                                    if (statusCategory == null) {
                                      return Container();
                                    }

                                    return Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const CircleAvatar(
                                          radius: 6,
                                          backgroundColor: Colors.red,
                                        ),
                                        const SizedBox.square(dimension: 8),
                                        Text(
                                          statusCategory.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                const SizedBox.square(dimension: 8),
                                Text(
                                  issue.key,
                                  textAlign: TextAlign.end,
                                  style: Theme.of(context).textTheme.overline,
                                ),
                              ],
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
        ),
      ],
    );
  }
}
