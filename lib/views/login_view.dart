import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/views/register_view.dart';
import '../firebase_options.dart';
class LoginView extends StatefulWidget{
  const LoginView({super.key});

  // const myApp(Key? key) : super(key : key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
    return /*Scaffold(
      appBar: AppBar(title:const Text("Login")),
      body: */Column(
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
              final email = _email.text;
              final password = _password.text;
              final userCredentials = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
              print(userCredentials);
              }, child: const Text('Login')),
              TextButton(
                onPressed:() => {
                  Navigator.of(context).push(MaterialPageRoute(builder:(context){
                        return const RegisterView(); // navigate to register page by pushing it to stack
                        }
                      )
                    )
                  },
                child: const Text("Don't have an account? Register Now!"),
                )
              ]
            );
    // );
        }
  }