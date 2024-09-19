import 'package:flutter/material.dart';
import 'package:notes/constants/routes.dart';
import 'package:notes/services/auth/auth_service.dart';

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
                  final confirmation = await logOut(context);
                  // devtools.log(confirmation.toString()); // prints the confirmation boolean
                  if(confirmation){
                    await AuthService.firebase().logout();
                    Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (_)=> false); // move to the login page upon logout
                  }
                  break;
              }
            },
            itemBuilder: (context) { return const [ // itembuilder will return only a list<popupmenuentry<MenuAction>>  type -> note that popupMenuItem is a subclass of popupMenuEntry as it extends popupMenuEntry
                 PopupMenuItem(value: MenuAction.logout, child: Text("logout")), // the value passed here will be passed on to the onSelected() function defined above as the value parameter
            ];
           }
          )
        ],
      ),
    );
  }
}

// implementation of the logout confirmation dialog
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