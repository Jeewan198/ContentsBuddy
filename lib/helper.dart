import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart'; //import these

import 'contacts.dart';

class DBHelper {
  static Future<Database> initDB() async {
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, 'contacts.db');
    //this is to create database
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  //build _onCreate function
  static Future _onCreate(Database db, int version) async {
    final sql = '''CREATE TABLE contacts(
      id INTEGER PRIMARY KEY,
      name TEXT,
      contact TEXT
    )''';
    await db.execute(sql);
  }

  //build create function (insert)
  static Future<int> createContacts(Contact contact) async {
    Database db = await DBHelper.initDB();
    //create contact using insert()
    return await db.insert('contacts', contact.toJson());
  }

  //build read function
  static Future<List<Contact>> readContacts() async {
    Database db = await DBHelper.initDB();
    var contact = await db.query('contacts', orderBy: 'name');
    List<Contact> contactList = contact.isNotEmpty
        ? contact.map((details) => Contact.fromJson(details)).toList()
        : [];
    return contactList;
  }

  //build update function
  static Future<int> updateContacts(Contact contact) async {
    Database db = await DBHelper.initDB();
    //update the existing contact
    //according to its id
    return await db.update('contacts', contact.toJson(),
        where: 'id = ?', whereArgs: [contact.id]);
  }

  //build delete function
  static Future<int> deleteContacts(int id) async {
    Database db = await DBHelper.initDB();
    //delete existing contact
    //according to its id
    return await db.delete('contacts', where: 'id = ?', whereArgs: [id]);
  }
}
