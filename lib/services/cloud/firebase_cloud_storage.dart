// singleton constructor
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/services/cloud/cloud_note.dart';
import 'package:notes/services/cloud/cloud_storage_constants.dart';
import 'package:notes/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes'); // get the notes

  void creaetNewNote({required String ownerUserId}) async {
    await notes.add({
      OwnerUserIdFieldName: ownerUserId,
      TextFieldName: '',
    });
  }

  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(
            OwnerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then(
            (value) => value.docs.map(
              (doc) {
                return CloudNote(
                  ownerUserId: doc.data()[OwnerUserIdFieldName] as String,
                  text: doc.data()[TextFieldName] as String,
                  documentId: doc.id,
                );
              },
            ),
          );
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  Stream<Iterable<CloudNote>> allNote({required String ownerUserId}) {
    return notes.snapshots().map((event) => event.docs
        .map((doc) => CloudNote.fromSnapshot(doc))
        .where((doc) => doc.ownerUserId == ownerUserId));
  }

  Future<void> updateNote(
      {required String documentId, required String text}) async {
    try {
      await notes.doc(documentId).update({
        TextFieldName: text
      }); // you give the path of document as documentId and update it to text
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
