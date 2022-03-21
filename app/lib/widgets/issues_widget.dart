import 'package:flutter/material.dart';
import 'package:sure_project_manager/models/issue.dart';
import 'package:sure_project_manager/models/project.dart';

class IssuesWidget extends StatefulWidget {
  const IssuesWidget({Key? key, required this.project}) : super(key: key);

  final Project project;

  @override
  State<IssuesWidget> createState() => _IssuesWidgetState();
}

class _IssuesWidgetState extends State<IssuesWidget> {
  Future<Search>? _searchFuture;

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
          trailing: FutureBuilder(
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
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  mainAxisExtent: 180,
                  maxCrossAxisExtent: 300,
                ),
                itemBuilder: (context, index) {
                  final issue = issues.elementAt(index);

                  Future<void> onTap() async {
                    // TODO: fix

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

class IssueDialogWidget extends StatefulWidget {
  const IssueDialogWidget({
    Key? key,
    required this.issue,
    required this.project,
  }) : super(key: key);

  final Issue issue;
  final Project project;

  @override
  State<IssueDialogWidget> createState() => _IssueDialogWidgetState();
}

class _IssueDialogWidgetState extends State<IssueDialogWidget> {
  final _summaryFocusNode = FocusNode();
  final _summaryController = TextEditingController();

  final _descriptionFocusNode = FocusNode();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final issue = widget.issue;

    _summaryController.text = issue.fields.summary ?? '';
    _descriptionController.text = issue.fields.description?.compute() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final issue = widget.issue;

    // TODO: fix, will pop scope
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints.loose(const Size.fromWidth(900)),
        child: Dialog(
          clipBehavior: Clip.antiAlias,
          child: Scaffold(
            appBar: AppBar(
              title: Builder(
                builder: (context) {
                  final project = widget.project;

                  return Text(
                    '${project.key} / ${issue.key}',
                    style: Theme.of(context).textTheme.overline,
                  );
                },
              ),
            ),
            body: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // TODO: fix, finish the layout
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextFormField(
                          focusNode: _summaryFocusNode,
                          controller: _summaryController,
                          decoration: const InputDecoration(
                            label: Text('Summary'),
                            alignLabelWithHint: true,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextFormField(
                          minLines: 1,
                          maxLines: 10,
                          focusNode: _descriptionFocusNode,
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            label: Text('Description'),
                            alignLabelWithHint: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
