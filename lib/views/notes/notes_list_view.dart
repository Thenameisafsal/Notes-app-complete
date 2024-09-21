import 'package:flutter/material.dart';
import 'package:notes/services/crud/notes_service.dart';
import 'package:notes/utilities/dialogs/delete_dialog.dart';

typedef NoteCallBack = void Function(DataBaseNote note);

class NotesListView extends StatelessWidget {
  final List<DataBaseNote> notes;
  final NoteCallBack onDeleteNote;
  final NoteCallBack onTap;
  const NotesListView(
      {super.key, required this.notes, required this.onDeleteNote, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index]; // get current note
        return ListTile(
          onTap: () {
            onTap(note);
          },
          // display notes in a list view
          title: Text(
            note.text,
            maxLines: 2, // max allowed ines to display
            softWrap: true,
            overflow: TextOverflow.ellipsis, // make the overflow words marked with '...'
          ),
          // specify what widget comes at the end of each item
          trailing: IconButton(
            onPressed: () async{
              final shouldDelete = await showDeleteDialog(context);
              if(shouldDelete){
                onDeleteNote(note);
              }
            },
             icon: const Icon(Icons.delete)
             ),
        );
      },
    );
  }
}
