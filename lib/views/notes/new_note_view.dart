import 'package:flutter/material.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/utilities/generics/get_arguments.dart';
import 'package:notes/services/cloud/cloud_note.dart';
import 'package:notes/services/cloud/cloud_storage_exceptions.dart';
import 'package:notes/services/cloud/firebase_cloud_storage.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({super.key});

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  // keep reference of these two vars to avoid defining them each time - singleton
  CloudNote? _note;
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
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
    await _notesService.updateNote(documentId: note.documentId, text: text);
  }

  void _setupTextControllerListener() {
    // refresh the listener
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<CloudNote> createOrGetExisitngNote(BuildContext context) async {
    final widgetNote = context.getArgument<CloudNote>();
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
    final userId = user.id;
    final newNote = await _notesService.createNewNote(
        ownerUserId: userId); // create the note
    _note = newNote;
    return newNote;
  }

  void deleteNoteIfEmpty() {
    final note = _note;
    //  if no text entered, delete it
    if (_textController.text.isEmpty && note != null) {
      _notesService.deleteNote(documentId: note.documentId);
    }
  }

  void saveNoteIfNotempty() async {
    final note = _note;
    final text = _textController.text;
    // if there is text, save it
    if (note != null && text.isNotEmpty) {
      await _notesService.updateNote(documentId: note.documentId, text: text);
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
