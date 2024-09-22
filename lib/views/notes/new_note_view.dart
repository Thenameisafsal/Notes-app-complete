import 'package:flutter/material.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/services/crud/notes_service.dart';
import 'package:notes/utilities/generics/get_arguments.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({super.key});

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  // keep reference of these two vars to avoid defining them each time - singleton
  DataBaseNote? _note;
  late final NotesService _notesService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _notesService = NotesService();
    _textController = TextEditingController();
    super.initState();
  }

// update db as the user types data
  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _notesService.updateNote(note: note, text: text);
  }

  void _setupTextControllerListener() {
    // refresh the listener
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<DataBaseNote> createOrGetExisitngNote(BuildContext context) async {
    final widgetNote = context.getArgument<DataBaseNote>();
    // update existing note
    if (widgetNote != null) {
      _note = widgetNote;
      _textController.text = widgetNote.text;
      return widgetNote;
    }
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final user =
        AuthService.firebase().currentUser!; // crash if user doesn't exist
    final email = user.email;
    final owner = await _notesService.getUser(email: email); // get the owner
    final newNote =
        await _notesService.createNote(owner: owner); // create the note
    _note = newNote;
    return newNote;
  }

  void deleteNoteIfEmpty() {
    final note = _note;
    //  if no text entered, delete it
    if (_textController.text.isEmpty && note != null) {
      _notesService.deleteNote(id: note.id);
    }
  }

  void saveNoteIfNotempty() async {
    final note = _note;
    final text = _textController.text;
    // if there is text, save it
    if (note != null && text.isNotEmpty) {
      await _notesService.updateNote(note: note, text: text);
    }
  }

// dispose the data and widgets
  @override
  void dispose() {
    deleteNoteIfEmpty();
    saveNoteIfNotempty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Note"),
      ),
      body: FutureBuilder(
          future: createOrGetExisitngNote(context),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                _setupTextControllerListener(); // start listening
                return TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration:
                      const InputDecoration(hintText: "Enter your notes here"),
                );
              default:
                return const CircularProgressIndicator();
            }
          }),
    );
  }
}
