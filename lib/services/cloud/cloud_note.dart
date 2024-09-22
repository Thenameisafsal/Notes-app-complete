import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/services/cloud/cloud_storage_constants.dart';

class CloudNote {
  final String ownerUserId;
  final String text;
  final String documentId;

  CloudNote({
    required this.ownerUserId,
    required this.text,
    required this.documentId,
  });

  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[OwnerUserIdFieldName],
        text = snapshot.data()[TextFieldName] as String;
}
