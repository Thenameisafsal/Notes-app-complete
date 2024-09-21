import 'package:flutter/material.dart';
import 'package:notes/constants/routes.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/views/login_view.dart';
import 'package:notes/views/register_view.dart';
import 'package:notes/views/verify_email_view.dart';
import 'package:notes/views/notes/notes_view.dart';
import 'package:notes/views/notes/new_note_view.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title:  "Notes App",
    theme: ThemeData(primarySwatch: Colors.blue),
    home: const  HomePage(),
    // named routes
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      notesRoute: (context) => const NotesView(),
      verifyEmailRoute: (context) => const VerifyEmailView(),
      newNoteRoute: (context) => const NewNoteView(),
    }
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context){
    return FutureBuilder(
        future: AuthService.firebase().startService(),
        builder: (context, snapshot){
              switch(snapshot.connectionState){
                case ConnectionState.done:
                  final user = AuthService.firebase().currentUser;
                  if(user!=null){
                    if(user.isEmailVerified){
                         return const NotesView();
                    }
                    else{
                         return const VerifyEmailView();
                    }
                  }
                  else{
                    return const LoginView();
                  }
                default:
                  // return const Text("Please wait, loading.");
                  return const CircularProgressIndicator(); // loading animation
              }
          }
      );
    }
}

Future<bool> logOut(BuildContext context){
  return showDialog<bool>(
        context : context,
        builder: (context){
        return AlertDialog(title: const Text('Logout'),
            content: const Text("You really want to log out?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text("Cancel")
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text("Log Out")
                ),
              ],
            );
      },
  ).then((value) => value ?? false); // since this is an optional future we make sure to return a future by checking for the null value return
}
