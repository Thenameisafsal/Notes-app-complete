import 'package:flutter/material.dart';
import 'package:notes/constants/routes.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/services/crud/notes_service.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

enum MenuAction { logout } // define the enumeration

class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email!;
  @override
  void initState() {
    _notesService = NotesService();
    _notesService.open();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Notes"),
        actions: [
          // the logout option in the menu
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(newNoteRoute); // move to new notes page
              },
              icon: const Icon(Icons.add) // add the + button
              ),
          PopupMenuButton<MenuAction>(onSelected: (value) async {
            switch (value) {
              case MenuAction.logout:
                final confirmation = await logOut(context);
                // devtools.log(confirmation.toString()); // prints the confirmation boolean
                if (confirmation) {
                  await AuthService.firebase().logout();
                  Navigator.of(context).pushNamedAndRemoveUntil(loginRoute,
                      (_) => false); // move to the login page upon logout
                }
                break;
            }
          }, itemBuilder: (context) {
            return const [
              // itembuilder will return only a list<popupmenuentry<MenuAction>>  type -> note that popupMenuItem is a subclass of popupMenuEntry as it extends popupMenuEntry
              PopupMenuItem(
                  value: MenuAction.logout,
                  child: Text(
                      "logout")), // the value passed here will be passed on to the onSelected() function defined above as the value parameter
            ];
          })
        ],
      ),
      body: FutureBuilder(
          future: _notesService.getOrCreateUser(email: userEmail),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return StreamBuilder(
                  stream: _notesService.allNotes,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      // implicit follow through - no break b/w two cases so they follow through the next case
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        if (snapshot.hasData) {
                          final allNotes = snapshot.data as List<DataBaseNote>;
                          return ListView.builder(
                            itemCount: allNotes.length,
                            itemBuilder: (context, index) {
                              final note = allNotes[index]; // get current note
                              return ListTile( // display notes in a list view
                                title: Text(
                                  note.text,
                                  maxLines: 2, // max allowed ines to display
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis, // make the overflow words marked with '...'
                                ),
                              );
                            },
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      default:
                        return const CircularProgressIndicator();
                    }
                  },
                );
              default:
                return const CircularProgressIndicator();
            }
          }),
    );
  }
}

// implementation of the logout confirmation dialog
Future<bool> logOut(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Logout'),
        content: const Text("You really want to log out?"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Cancel")),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Log Out")),
        ],
      );
    },
  ).then((value) =>
      value ??
      false); // since this is an optional future we make sure to return a future by checking for the null value return
}
