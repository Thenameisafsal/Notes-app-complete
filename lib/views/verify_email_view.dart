import 'package:flutter/material.dart';
import 'package:notes/constants/routes.dart';
import 'package:notes/services/auth/auth_service.dart';
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
            const Text("We've sent you an email, please check it to verify your account"),
            const Text("If you didn't receive an email, please click on the button below."),
            // verify the user by invoking sendEmailVerification()
            TextButton(onPressed: () async{
                  final user = AuthService.firebase().currentUser;
                  await AuthService.firebase().sendEmailVerification();
                  if(user!=null){
                    if(user.isEmailVerified) {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {return const LoginView();}));
                    } // if the user has the email verified, we need to ask him to login because it won't be updated in the app just because he has verified
                  }
              }, 
              child: const Text("Verify")
              ),
              TextButton(onPressed: () async {
                AuthService.firebase().logout(); // sign out the user to refresh the state of user
                Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route)=>false); // move to the register page
              }, child: const Text("Sign out to refresh the page"))
            ]
          ),
    );
  }
}
