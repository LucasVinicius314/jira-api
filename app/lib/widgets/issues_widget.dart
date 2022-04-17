import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sure_project_manager/models/issue.dart';
import 'package:sure_project_manager/models/project.dart';
import 'package:sure_project_manager/utils/services/pdf.dart';
import 'package:sure_project_manager/widgets/issue_dialog_widget.dart';

enum IssueTypes {
  story,
  task,
  subTask,
  bug,
  epic,
}

const issueTypeToString = {
  IssueTypes.story: 'Story',
  IssueTypes.task: 'Task',
  IssueTypes.subTask: 'Sub-task',
  IssueTypes.bug: 'Bug',
  IssueTypes.epic: 'Epic',
};

class IssuesWidget extends StatefulWidget {
  const IssuesWidget({Key? key, required this.project}) : super(key: key);

  final Project project;

  @override
  State<IssuesWidget> createState() => _IssuesWidgetState();
}

class _IssuesWidgetState extends State<IssuesWidget> {
  Future<Search>? _searchFuture;

  Set<IssueTypes> _issueTypes = {};

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
      _searchFuture = Issue.search(issueTypes: _issueTypes);
    });
  }

  Future<void> _filter() async {
    final ans = await showModalBottomSheet(
      context: context,
      builder: (context) {
        return FilterModalBottomSheet(issueTypes: _issueTypes);
      },
    );

    if (ans is Set<IssueTypes>) {
      setState(() {
        _issueTypes = ans;
      });

      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        _fetchSearch();
      });
    }
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
                    tooltip: 'Filter',
                    icon: const Icon(Icons.filter_alt),
                    onPressed: waiting ? null : _filter,
                  );
                },
              ),
              const SizedBox(width: 16),
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

                  return IssueCard(issue: issue, onTap: onTap);
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

class IssueCard extends StatelessWidget {
  const IssueCard({
    Key? key,
    required this.issue,
    required this.onTap,
  }) : super(key: key);

  final Issue issue;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          issue.fields.summary ?? '',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Text(
                          issue.fields.description?.compute() ?? '',
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

                      final issueType = issue.fields.issuetype;

                      if (statusCategory == null || issueType == null) {
                        return Container();
                      }

                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Tooltip(
                            message: issueType.name,
                            child: SvgPicture.network(
                              issueType.iconUrl,
                              width: 12,
                              height: 12,
                            ),
                          ),
                          const SizedBox.square(dimension: 4),
                          const CircleAvatar(
                            radius: 6,
                            backgroundColor: Colors.red,
                          ),
                          const SizedBox.square(dimension: 8),
                          Text(
                            statusCategory.name,
                            style: Theme.of(context).textTheme.caption,
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
  }
}

class FilterModalBottomSheet extends StatefulWidget {
  const FilterModalBottomSheet({Key? key, required this.issueTypes})
      : super(key: key);

  final Set<IssueTypes> issueTypes;

  @override
  State<FilterModalBottomSheet> createState() => _FilterModalBottomSheetState();
}

class _FilterModalBottomSheetState extends State<FilterModalBottomSheet> {
  Set<IssueTypes> _issueTypes = {};

  @override
  void initState() {
    super.initState();

    _issueTypes = widget.issueTypes;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints.loose(const Size.fromWidth(900)),
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Filter',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    TextButton(
                      child: const Text('APPLY'),
                      onPressed: () async {
                        await Navigator.of(context).maybePop(_issueTypes);
                      },
                    )
                  ],
                ),
              ),
              SwitchListTile(
                value: _issueTypes.contains(IssueTypes.story),
                title: const Text('Stories'),
                onChanged: (value) {
                  setState(() {
                    if (value) {
                      _issueTypes.add(IssueTypes.story);
                    } else {
                      _issueTypes.remove(IssueTypes.story);
                    }
                  });
                },
              ),
              SwitchListTile(
                value: _issueTypes.contains(IssueTypes.task),
                title: const Text('Tasks'),
                onChanged: (value) {
                  setState(() {
                    if (value) {
                      _issueTypes.add(IssueTypes.task);
                    } else {
                      _issueTypes.remove(IssueTypes.task);
                    }
                  });
                },
              ),
              SwitchListTile(
                value: _issueTypes.contains(IssueTypes.subTask),
                title: const Text('Sub-tasks'),
                onChanged: (value) {
                  setState(() {
                    if (value) {
                      _issueTypes.add(IssueTypes.subTask);
                    } else {
                      _issueTypes.remove(IssueTypes.subTask);
                    }
                  });
                },
              ),
              SwitchListTile(
                value: _issueTypes.contains(IssueTypes.bug),
                title: const Text('Bugs'),
                onChanged: (value) {
                  setState(() {
                    if (value) {
                      _issueTypes.add(IssueTypes.bug);
                    } else {
                      _issueTypes.remove(IssueTypes.bug);
                    }
                  });
                },
              ),
              SwitchListTile(
                value: _issueTypes.contains(IssueTypes.epic),
                title: const Text('Epics'),
                onChanged: (value) {
                  setState(() {
                    if (value) {
                      _issueTypes.add(IssueTypes.epic);
                    } else {
                      _issueTypes.remove(IssueTypes.epic);
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
