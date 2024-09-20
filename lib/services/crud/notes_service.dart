import 'package:flutter/foundation.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart'; // used to get the documents of the application
import 'package:sqflite/sqflite.dart';
import 'package:notes/services/crud/crud_exceptions.dart';

class NotesService {
  Database? _db;
  Database _getDataBaseOrThrow(){
    final database = _db;
    if(database == null){ throw DataBaseIsNotOpenException();}
    else{
      return database;
    }
  }

  Future<void> close() async{
    final db = _db;
    if(db==null){ throw DataBaseIsNotOpenException();}
    else{
      await db.close(); // close the db
      _db = null;
    }
  }

  Future<DataBaseUser> getUser({required String email}) async{
    final db = _getDataBaseOrThrow();
    final results = await db.query(userTable,limit:1,where: 'email = ?',whereArgs: [email.toLowerCase()]);
    if(results.isEmpty){
      throw CouldNotFindUser();
    }
    else{
      return DataBaseUser.fromRow(results.first);
    }
  }

  Future<void> deleteUser({required String email}) async{
    final db = _getDataBaseOrThrow();
    final deletedCount = await db.delete(userTable,where: 'email = ?', whereArgs: [email.toLowerCase()]);
    if(deletedCount != 1){
      throw CouldNotDeleteUserException();
    }
  }

  Future<DataBaseUser> createUser({required String email}) async{
    final db = _getDataBaseOrThrow();
    final results = await db.query(userTable, limit:1,where: 'email = ?',whereArgs: [email.toLowerCase()]); // query the userTable - limit 1 means get only 1 result - and here you're searching the email
    if(results.isNotEmpty){
      throw UserAlreadyExistsException();
    }
    final userId = await db.insert(userTable, {emailColumn: email.toLowerCase()});
    return DataBaseUser(id: userId, email: email);
  }

  Future<void> open() async {
    if (_db != null) {
      // db is already open in this case
      throw DataBaseAlreadyOpenException();
    }

    try {
      final docsPath =
          await getApplicationDocumentsDirectory(); // get path of docs
      final dbPath = join(docsPath.path, dbName); // create dbpath
      final db = await openDatabase(dbPath); // open the db
      _db = db;

      await db.execute(createUserTable); // execute the sql query

      await db.execute(createNoteTable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }

  Future<DataBaseNote> createNote({required DataBaseUser owner}) async{
    final db = _getDataBaseOrThrow();
    final dbUser = await getUser(email: owner.email); // get the current user
    if(dbUser != owner){
      throw CouldNotFindUser(); // this case indicates that unauthorized access has occurred
    }
    const text = '';
    final noteId = await db.insert(noteTable, {
      userIdColumn: owner.id,
      textColumn: text
    }
  );

    final note = DataBaseNote(id: noteId, userId: owner.id, text: text);
    return note;
  }

  Future<void> deleteNote({required int id}) async{
    final db = _getDataBaseOrThrow();
    final deleteCount = await db.delete(noteTable,where: 'id = ?',whereArgs: [id]);
    if(deleteCount==0){
      throw CouldNotDelete();
    }
  }

  Future<int> deleteAllNotes() async{
    final db = _getDataBaseOrThrow();
    return await db.delete(noteTable); // deletes everything
  }

  Future<DataBaseNote> getNote({required int id}) async{
    final db = _getDataBaseOrThrow();
    final notes = await db.query(noteTable,limit:1,where: 'id = ?',whereArgs: [id]);
    if(notes.isEmpty){
      throw CouldNotFindNotes();
    }
    return DataBaseNote.fromRow(notes.first);
  }

  Future<Iterable<DataBaseNote>> getallNotes() async{
    final db = _getDataBaseOrThrow();
    final notes = await db.query(noteTable,);
    final result = notes.map((noteRow) => DataBaseNote.fromRow(noteRow)); // convert the map<String,Object?> to an iterable
    return result;
  }

  Future<DataBaseNote> updateNode({required DataBaseNote note, required String text}) async{
    final db = _getDataBaseOrThrow();
    await getNote(id: note.id); // make sure the query note exists - if it doesn't an exception is thrown
    final updatesCount = await db.update(noteTable, {textColumn: text});
    if(updatesCount == 0){
      throw CouldNotUpdate();
    }
    else{
      return await getNote(id: note.id); // return the query node
    }
  }
}

@immutable
class DataBaseUser {
  final int id;
  final String email;
  const DataBaseUser({required this.id, required this.email});

  DataBaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() {
    return 'Person, ID = $id ,email = $email';
  }

  @override
  bool operator ==(covariant DataBaseUser other) {
    return id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}

class DataBaseNote {
  final int id;
  final int userId;
  final String text;
  DataBaseNote({required this.id, required this.userId, required this.text});
  DataBaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String;

  @override
  String toString() => 'Note, ID = $id, userId = $userId';
  @override
  bool operator ==(covariant DataBaseUser other) {
    return id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}

const dbName = 'notes.db';
const noteTable = 'note';
const userTable = 'user';
const idColumn = 'id';
const emailColumn = 'email';
const userIdColumn = 'user_id';
const textColumn = 'text';

// create table in case it doens't exist
const createUserTable = '''
    CREATE TABLE IF NOT EXISTS "user" (
    "id"	INTEGER NOT NULL,
    "email"	TEXT NOT NULL UNIQUE,
    PRIMARY KEY("id" AUTOINCREMENT)
  );
'''; // paste other language queries here - here we pasted sql query

const createNoteTable = '''
          CREATE TABLE IF NOT EXISTS "note" (
          "id"	INTEGER NOT NULL,
          "user_id"	INTEGER NOT NULL,
          "note_text"	TEXT,
          PRIMARY KEY("id" AUTOINCREMENT),
          FOREIGN KEY("user_id") REFERENCES "user"("id")
          );
''';