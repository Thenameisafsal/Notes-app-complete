import 'package:flutter/material.dart';
import 'package:notes/services/auth/auth_exceptions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/services/auth/bloc/auth_bloc.dart';
import 'package:notes/services/auth/bloc/auth_event.dart';
import 'package:notes/services/auth/bloc/auth_state.dart';
import 'package:notes/utilities/dialogs/error_dialog.dart';
import 'package:notes/constants/routes.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  // const myApp(Key? key) : super(key : key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Column(
        children: [
          TextField(
            controller: _email,
            autocorrect: false,
            enableSuggestions: false,
            keyboardType: TextInputType.emailAddress,
            decoration:
                const InputDecoration(hintText: "Please enter you email here"),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
            decoration:
                const InputDecoration(hintText: "Enter your password here"),
          ),
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) async {
              if (state is AuthStateLoggedOut) {
                // logged out because of exception
                if (state.exception is UserNotFoundAuthException) {
                  await showErrorDialog(context, "User not found!");
                } else if (state.exception is InvalidPasswordAuthException) {
                  await showErrorDialog(context, "Invalid email/  password!");
                } else {
                  await showErrorDialog(
                      context, "Some error occurred, try again later.");
                }
              }
            },
            child: TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                context
                    .read<AuthBloc>()
                    .add(AuthEventLogIn(email: email, password: password));
              },
              child: const Text('Login'),
            ),
          ),
          TextButton(
            onPressed: () => {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (route) => false),
            },
            child: const Text("Don't have an account? Register Now!"),
          ),
        ],
      ),
    );
  }
}
