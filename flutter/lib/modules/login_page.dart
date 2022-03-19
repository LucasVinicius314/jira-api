import 'package:flutter/material.dart';
import 'package:jira_api/exceptions/invalid_request_exception.dart';
import 'package:jira_api/models/user_4.dart';
import 'package:jira_api/modules/main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const route = 'login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _waiting = false;

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> _login() async {
    if (_formKey.currentState?.validate() != true) return;

    try {
      setState(() {
        _waiting = true;
      });

      final email = _emailController.text;
      final password = _passwordController.text;

      final user = await User.login(email: email, password: password);

      // TODO: fix, provider

      await Navigator.of(context).pushReplacementNamed(MainPage.route);
    } on InvalidRequestException catch (e) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Warning'),
            content: Text(e.message),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).maybePop();
                },
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        _waiting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints.loose(
                      const Size.fromWidth(360),
                    ),
                    child: Card(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: TextFormField(
                                focusNode: _emailFocusNode,
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  label: Text('Email'),
                                  alignLabelWithHint: true,
                                ),
                                validator: (value) {
                                  value ??= '';

                                  if (value.length <= 4) {
                                    return 'Invalid email.';
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: TextFormField(
                                obscureText: true,
                                focusNode: _passwordFocusNode,
                                controller: _passwordController,
                                decoration: const InputDecoration(
                                  label: Text('Password'),
                                  alignLabelWithHint: true,
                                ),
                                validator: (value) {
                                  value ??= '';

                                  if (value.length <= 4) {
                                    return 'Invalid password.';
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: ElevatedButton(
                                onPressed: _waiting ? null : _login,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Visibility(
                                      visible: !_waiting,
                                      maintainSize: true,
                                      maintainState: true,
                                      maintainAnimation: true,
                                      maintainSemantics: true,
                                      maintainInteractivity: true,
                                      child: const Text(
                                        'LOGIN',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Visibility(
                                      visible: _waiting,
                                      maintainSize: true,
                                      maintainState: true,
                                      maintainAnimation: true,
                                      maintainSemantics: true,
                                      maintainInteractivity: true,
                                      child: SizedBox.square(
                                        dimension: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color:
                                              Theme.of(context).disabledColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
