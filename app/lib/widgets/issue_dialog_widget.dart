import 'package:flutter/material.dart';
import 'package:sure_project_manager/models/issue.dart';
import 'package:sure_project_manager/models/project.dart';

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
