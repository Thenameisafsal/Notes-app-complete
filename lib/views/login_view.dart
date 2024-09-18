import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devtools;
import 'package:notes/utilities/showerrordialog.dart';
import 'package:notes/constants/routes.dart';

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
    return Scaffold(
      appBar: AppBar(title:const Text("Login")),
      body: Column(
        children:[
            TextField(
            controller: _email, 
            autocorrect: false,
            enableSuggestions: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: "Please enter you email here"),),
            TextField(
              controller: _password, 
              obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
              decoration: const InputDecoration(hintText: "Enter your password here"),),
            TextButton(onPressed: () async { 
              final email = _email.text;
              final password = _password.text;
              try{
              final userCredentials = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
              devtools.log(userCredentials.toString());
              final user = FirebaseAuth.instance.currentUser;
              if(user?.emailVerified ?? false){
                Navigator.of(context).pushNamedAndRemoveUntil(notesRoute, (route) => false); // redirect to the notes view as usere has logged in
              }
              else{
                await showErrorDialog(context,"We noticed you haven't verified your email yet. Please verify the email before you can proceed.");
                Navigator.of(context).pushNamedAndRemoveUntil(verifyEmailRoute, (route) => false); // redirect to verifyEmailView if he's not registered
              }
              } on FirebaseAuthException catch(e) {
                  devtools.log(e.code);
                  if(e.code == 'invalid-credential'){
                    // devtools.log("User is not found!");
                    await showErrorDialog(context, 'Invalid Credentials!');
                  }
                  else if(e.code == 'invalid-password'){
                    // devtools.log("Password is incorrect!");
                    await showErrorDialog(context, 'wrong password');
                  }
                  else{
                    await showErrorDialog(context, 'An error occurred, please try again!');
                  }
              } catch(e){
                await showErrorDialog(context, 'There was an unexpected error: $e.code');
              }
              },
              child: const Text('Login'),),
              TextButton(
                onPressed:() => {
                  Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false),
                  },
                child: const Text("Don't have an account? Register Now!"),
                ),
              ],
            ),
        );
      }                
  }