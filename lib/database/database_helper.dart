import 'package:contact_app/models/contact.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) return _db;
    _db = await initDB();
    return _db;
  }

  Future<Database> initDB() async {
    io.Directory docDirectory = await getApplicationDocumentsDirectory();
    String path = join(docDirectory.path, 'contactDB.db');
    var localDB = await openDatabase(path,
        version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return localDB;
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      if (!(await columnExists(db, 'contact', 'warna'))) {
        await db.execute('ALTER TABLE contact ADD COLUMN warna text');
      }
      if (!(await columnExists(db, 'contact', 'date'))) {
        await db.execute('ALTER TABLE contact ADD COLUMN date text');
      }
    }
  }

  Future<bool> columnExists(
      Database db, String tableName, String columnName) async {
    var result = await db.rawQuery('PRAGMA table_info($tableName)');
    return result.any((column) => column['name'] == columnName);
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      create table if not exists contact(
        id integer primary key autoIncrement,
        nama text not null,
        number text not null,
        foto text,
        kategori text,
        warna text,
        date text
      )
      ''');
  }

  Future<void> deleteAllData() async {
    var dbClient = await db;

    if (dbClient != null) {
      await dbClient.delete('contact');
    }
  }

  Future<List<Contact>> getAllContact() async {
    var dbClient = await db;
    var contacts = await dbClient!.query('contact');
    return contacts.map((contact) => Contact.fromMap(contact)).toList();
  }

  Future<List<Contact>> searchContact(String key) async {
    var dbClient = await db;
    var contacts = await dbClient!.query('contact',
        where: 'nama LIKE ? OR number LIKE ?', whereArgs: ['%$key%', '%$key%']);
    return contacts.map((contact) => Contact.fromMap(contact)).toList();
  }

  Future<int> addContact(Contact contact) async {
    var dbClient = await db;
    return await dbClient!.insert('contact', contact.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateContact(Contact contact) async {
    var dbClient = await db;
    return await dbClient!.update('contact', contact.toMap(),
        where: 'id=?', whereArgs: [contact.id]);
  }

  Future<int> deleteContact(int id) async {
    var dbClient = await db;
    return await dbClient!.delete('contact', where: 'id=?', whereArgs: [id]);
  }
}
