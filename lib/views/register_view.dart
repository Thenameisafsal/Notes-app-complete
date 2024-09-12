import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devtools;
import 'package:notes/utilities/showerrordialog.dart';
import 'package:notes/constants/routes.dart';

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
                    final userCredentials = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
                    final user = FirebaseAuth.instance.currentUser;
                    await user?.sendEmailVerification();
                    devtools.log(userCredentials.toString());
                    // after registration push the verify email view
                    Navigator.of(context).pushNamed(verifyEmailRoute);
                    // to make sure the user can go back one step in case he entered a wrong mail or something, so use pushNamed() instead of using pushNamedAndRemoveUntil()
              } on FirebaseAuthException catch (e) {
                    if(e.code == 'weak-password'){
                        devtools.log("Weak password brother!");
                        await showErrorDialog(context, 'Weak password, please enter a stronger one.');
                    }
                    else if(e.code == 'email-already-in-use'){
                        devtools.log("Email already in use brother!");
                        await showErrorDialog(context, 'The email is already in use, please login using the email or register using a new one.');
                    }
                    else if(e.code == 'invalid-email'){
                        devtools.log("Invalid email brother!");
                        await showErrorDialog(context, 'Invalid Email.');
                    }
                    else{
                      await showErrorDialog(context, 'Something went wrong, ${e.code}.');
                    }
                } catch(e){
                  await showErrorDialog(context, e.toString());
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
