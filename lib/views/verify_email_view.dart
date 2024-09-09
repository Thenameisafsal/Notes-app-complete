import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/views/login_view.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children: [
            // TextButton(onPressed: (){
            //       Navigator.of(context).push(
            //         MaterialPageRoute(builder: (context){return const LoginView();}
            //         )
            //       );
            //     },
            //   child: const Text("login here")
            // ),
            const Text("Verify email here"),
            // verify the user by invoking sendEmailVerification()
            TextButton(onPressed: () async{
                  final userCredentials = await FirebaseAuth.instance.signInWithEmailAndPassword(email: "thenameisafsalahamad@gmail.com", password: "Who@re123");
                  final user = FirebaseAuth.instance.currentUser;
                  print(userCredentials);
                  await user?.sendEmailVerification();
                  if(user!=null){
                    if(user.emailVerified) {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {return const LoginView();}));
                    } // if the user has the email verified, we need to ask him to login because it won't be updated in the app just because he has verified
                  }
              }, 
              child: const Text("Verify email here")
              )
            ]
          ),
    );
  }
}
