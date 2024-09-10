import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes/views/login_view.dart';
import 'package:notes/views/register_view.dart';
import 'package:notes/views/verify_email_view.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devtools;
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
                  final user = FirebaseAuth.instance.currentUser;
                  if(user!=null){
                    if(user.emailVerified){
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


class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

enum MenuAction { logout } // define the enumeration

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(title: const Text("Notes UI"),
      actions: [
        // the logout option in the menu
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch(value){
                case MenuAction.logout:
                  final confirmation = await LogOut(context);
                  // devtools.log(confirmation.toString()); // prints the confirmation boolean
                  if(confirmation){
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil('/login/', (_)=> false); // move to the login page upon logout
                  }
                  break;
              }
            },
            itemBuilder: (context) { return const [ // itembuilder will return only a list<popupmenuentry<MenuAction>>  type -> note that popupMenuItem is a subclass of popupMenuEntry as it extends popupMenuEntry
                 PopupMenuItem(value: MenuAction.logout, child: Text("logout")) // the value passed here will be passed on to the onSelected() function defined above as the value parameter
            ];
           }
          )
        ],
      ),
    );
  }
}

// implementation of the logout confirmation dialog
Future<bool> LogOut(BuildContext context){
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
                )
              ],
            );
      }
  ).then((value) => value ?? false); // since this is an optional future we make sure to return a future by checking for the null value return
}