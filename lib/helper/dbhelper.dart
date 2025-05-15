import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';

// membuat file dan directory
import 'package:path_provider/path_provider.dart';
import 'package:tugas_database/model/contact.dart';

class DbHelper {
  static DbHelper? _dbHelper;
  static Database? _database;

  DbHelper._createObject();

  factory DbHelper() {
    _dbHelper ??= DbHelper._createObject();
    return _dbHelper!;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + '/contact.db';
    print('Database path: $path');

    var contactDb = await openDatabase(path, version: 1, onCreate: _createDb);
    return contactDb;
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE contact (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        namaKontak TEXT,
        nomorTelepon TEXT
      )
    ''');
    print('Database and table created');
  }

  Future<int> insert(Contact object) async {
    try {
      Database db = await database;
      int count = await db.insert('contact', object.toMap());
      print('Inserted contact with id: $count');
      return count;
    } catch (e) {
      print("Error saat menyisipkan data: $e");
      return -1;
    }
  }

  Future<int> update(Contact object) async {
    try {
      Database db = await database;
      int result = await db.update(
        'contact',
        object.toMap(),
        where: 'id = ?',
        whereArgs: [object.id],
      );
      print('Updated contact id: ${object.id}');
      return result;
    } catch (e) {
      print("Error saat memperbarui data: $e");
      return -1;
    }
  }

  Future<int> delete(int id) async {
    try {
      Database db = await database;
      int count = await db.delete('contact', where: 'id = ?', whereArgs: [id]);
      print('Deleted contact id: $id');
      return count;
    } catch (e) {
      print('Error saat menghapus data: $e');
      return -1;
    }
  }

  Future<List<Contact>> getContactList() async {
    var contactMapList = await getContactMapList();
    int count = contactMapList.length;
    List<Contact> contactList = <Contact>[];

    for (int i = 0; i < count; i++) {
      contactList.add(Contact.fromMapObject(contactMapList[i]));
    }
    return contactList;
  }

  Future<List<Map<String, dynamic>>> getContactMapList() async {
    try {
      Database db = await database;
      var result = await db.query('contact');
      return result;
    } catch (e) {
      print("Error saat mendapatkan map list: $e");
      return [];
    }
  }
}
