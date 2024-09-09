import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes/views/login_view.dart';
import 'package:notes/views/register_view.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
void main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title:  "Notes App",
    theme: ThemeData(primarySwatch: Colors.blue),
    home: const  HomePage(),
    // named routes
    routes: {
      '/login/': (context) => const LoginView(),
      '/register/': (context) => const RegisterView()
    }
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context){
    return FutureBuilder(
        future: Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
        builder: (context, snapshot){
              switch(snapshot.connectionState){
                case ConnectionState.done:
                  // final user = FirebaseAuth.instance.currentUser;
                  // if(user?.emailVerified ?? false){
                  //       return const Text("verified user"); // all good to go
                  // }
                  // else{
                  //   return const VerifyEmailView(); // return verify email since not verified yet
                  // }
                  return const LoginView();
                default:
                  // return const Text("Please wait, loading.");
                  return const CircularProgressIndicator(); // loading animation
              }
          }
        );
  }
}


// list of changes made:
// implemented named routes
// linked login and register views using the named routes -> use navigator.of(context).pushNamedAndRemoveUntil(named_route,(route)=>false)
// remove scaffold from home page as login page already has a scaffold and it is not a good idea to embed a scaffold on a scaffold
// add the scaffold to the verifyemail view instead
// circular progress indicator
// moved the verifyEmailView into its own file