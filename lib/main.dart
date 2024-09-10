import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes/views/login_view.dart';
import 'package:notes/views/register_view.dart';
import 'package:notes/views/verify_email_view.dart';
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
          PopupMenuButton<MenuAction>(
            onSelected: (value) => {},
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