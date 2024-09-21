import 'package:flutter/material.dart';
import 'package:notes/services/auth/auth_exceptions.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/constants/routes.dart';
import 'package:notes/utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget{
  const RegisterView({super.key});

  // const myApp(Key? key) : super(key : key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState(){
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }
  @override
  void dispose(){
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Column(
        children:[
            TextField(
            controller: _email, 
            autocorrect: false,
            enableSuggestions: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: "Please enter you email here")),
            TextField(
              controller: _password, 
              obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
            decoration: const InputDecoration(hintText: "Enter your password here")),
            TextButton(onPressed: () async { 
              try{
                    final email = _email.text;
                    final password = _password.text;
                    await AuthService.firebase().createUser(email: email, password: password);
                    final user = AuthService.firebase().currentUser;
                    AuthService.firebase().sendEmailVerification();
                    // after registration push the verify email view
                    Navigator.of(context).pushNamed(verifyEmailRoute);
                    // to make sure the user can go back one step in case he entered a wrong mail or something, so use pushNamed() instead of using pushNamedAndRemoveUntil()
              } on InvalidEmailAuthException{
                    await showErrorDialog(context, 'invalid email');
                } on WeakPasswordAuthException{
                    await showErrorDialog(context, 'weak password');
                } on EmailAlreadyExistsAuthException{
                    await showErrorDialog(context, 'Email already exists - try with another account.');
                } on GenericAuthException{
                  await showErrorDialog(context, 'some error occurred - try again later.');
                }
              },
              child: const Text('Register')),
              
              TextButton(onPressed: (){
                Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
               child: const Text("Login using an existing account."))
          ]
        )
      );
    }
  }
