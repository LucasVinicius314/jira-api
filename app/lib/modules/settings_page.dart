import 'package:flutter/material.dart';
import 'package:sure_project_manager/modules/splash_page.dart';
import 'package:sure_project_manager/providers/app_provider.dart';
import 'package:sure_project_manager/utils/services/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  static const route = 'settings';

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _titleFocusNode = FocusNode();

  final _membersController = TextEditingController();
  final _membersFocusNode = FocusNode();

  Future<void> _save() async {
    final title = _titleController.text;
    final members = _membersController.text;

    // TODO: fix, add validators
    if (_formKey.currentState?.validate() != true) return;

    await Future.wait([
      SharedPreferences.setTitle(title),
      SharedPreferences.setMembers(members),
    ]);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text(
            'Changes saved successfully!',
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(primary: Colors.green),
              child: const Text('OK'),
              onPressed: () async {
                await Navigator.of(context).maybePop();
                await Navigator.of(context).maybePop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      final title = (await SharedPreferences.title) ?? '';
      final members = (await SharedPreferences.members) ?? '';

      _titleController.text = title;
      _membersController.text = members;
    });

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
    return WillPopScope(
      onWillPop: () async {
        final newTitle = _titleController.text;
        final newMembers = _membersController.text;

        final oldTitle = (await SharedPreferences.title) ?? '';
        final oldMembers = (await SharedPreferences.members) ?? '';

        if ('$newTitle$newMembers' == '$oldTitle$oldMembers') return true;

        final ans = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Warning'),
              content: const Text(
                'Some settings have not been saved. Discard them anyway?',
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(primary: Colors.red),
                  child: const Text('NO'),
                  onPressed: () {
                    Navigator.of(context).maybePop();
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(primary: Colors.green),
                  child: const Text('YES'),
                  onPressed: () {
                    Navigator.of(context).maybePop(true);
                  },
                ),
              ],
            );
          },
        );

        if (ans == true) return true;

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const ListTile(
            title: Text('Sure Project Manager'),
            subtitle: Text('Settings'),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextButton(
                style: TextButton.styleFrom(primary: Colors.black),
                child: const Text('Save'),
                onPressed: _save,
              ),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints.loose(const Size.fromWidth(900)),
              child: ListView(
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
                          'Export settings',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text(
                          'Settings used when exporting issues to a PDF file.',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      focusNode: _titleFocusNode,
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        hintText: 'My project',
                        helperMaxLines: 10,
                        helperText:
                            'Used as the title of your exported issues document.',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      focusNode: _membersFocusNode,
                      controller: _membersController,
                      decoration: const InputDecoration(
                        labelText: 'Members',
                        hintText: 'Example: John Doe, Mark, Sam',
                        helperMaxLines: 10,
                        helperText:
                            'Used as the list of members on your exported issues document. Must be a comma-separated value (CSV). Example: John Doe, Mark, Sam',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
