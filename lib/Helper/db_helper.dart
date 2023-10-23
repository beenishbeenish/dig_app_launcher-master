import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
  DatabaseHelper();
  static const _databaseName = "DigAppLauncher.db";
  static const _databaseVersion = 1;

  static const tableLetterSize = 'AddLetterSize';
  static const tableContacts = 'AddContacts';
  static const tableEmergencyContacts = 'AddEmergencyContacts';
  static const tableSound = 'AddSound';
  static const tableMedicine = 'AddMedicine';
  static const tableLeisure = 'AddLeisure';

  static const columnId = 'id';

  //Letter Size Variables
  static const titleSize = 'titleSize';
  static const textSize = 'textSize';

  //Contacts Variables
  static const personName = 'personName';
  static const personImage = 'personImage';
  static const personPhoneNumber = 'personPhoneNumber';
  static const whatsapp = 'whatsapp';
  static const voiceCall = 'voiceCall';
  static const videoCall = 'videoCall';

  //Emergency Contacts Variables
  // static const emergencyContactsTime = 'emergencyContactsTime';
  static const emergencyContactsName = 'emergencyContactsName';
  static const emergencyContactsImage = 'emergencyContactsImage';
  static const emergencyContactsPhoneNumber = 'emergencyContactsPhoneNumber';

  //Sound Variable
  static const volume = 'volume';
  static const isBluetooth = 'isBluetooth';

  //Medicine Variables
  static const medicineName = 'medicineName';
  static const medicineImage = 'medicineImage';
  static const medicineHour = 'medicineHour';
  static const medicineMinute = 'medicineMinute';
  static const medicineTime = 'medicineTime';
  static const medicineDays = 'medicineDays';

  //Leisure Variables
  static const appName = 'appName';
  static const appImage = 'appImage';
  static const appUrl = 'appUrl';

  //Make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  //Only have a single app-wide reference to the database
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    //Lazily instantiate the db the first time it is accessed
    _database = await initDatabase();
    return _database!;
  }

  //This opens the database (and creates it if it doesn't exist)
  initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tableLetterSize (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,    
            $titleSize INTEGER,
            $textSize INTEGER
          )
          ''');

    await db.execute('''
          CREATE TABLE $tableContacts (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,    
            $personName TEXT,
            $personImage TEXT,
            $personPhoneNumber TEXT,
            $whatsapp TEXT,
            $voiceCall TEXT,
            $videoCall TEXT
          )
          ''');

    //$emergencyContactsTime INTEGER,
    await db.execute('''
          CREATE TABLE $tableEmergencyContacts (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,    
            $emergencyContactsName TEXT,
            $emergencyContactsImage TEXT,
            $emergencyContactsPhoneNumber TEXT
          )
          ''');

    await db.execute('''
          CREATE TABLE $tableSound (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,    
            $volume INTEGER,
            $isBluetooth TEXT
          )
          ''');

    await db.execute('''
          CREATE TABLE $tableMedicine (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,    
            $medicineName TEXT,
            $medicineImage TEXT,
            $medicineHour TEXT,
            $medicineMinute TEXT,
            $medicineTime TEXT,
            $medicineDays TEXT
          )
          ''');

    await db.execute('''
          CREATE TABLE $tableLeisure (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,    
            $appName TEXT,
            $appImage TEXT,
            $appUrl TEXT
          )
          ''');
  }

  //Insert Query
  Future<int> insertLetterSize(Map<String, dynamic> row) async {
    Database db = await instance.database;
    print('>>>>>>>>stored letter size in DB');

    return await db.insert(tableLetterSize, row);
  }

  Future<int> insertContacts(Map<String, dynamic> row) async {
    Database db = await instance.database;
    print('>>>>>>>>stored contacts data in DB');

    return await db.insert(tableContacts, row);
  }

  Future<int> insertEmergencyContacts(Map<String, dynamic> row) async {
    Database db = await instance.database;
    print('>>>>>>>>stored emergency contacts data in DB');

    return await db.insert(tableEmergencyContacts, row);
  }

  Future<int> insertSound(Map<String, dynamic> row) async {
    Database db = await instance.database;
    print('>>>>>>>>stored sound data in DB');

    return await db.insert(tableSound, row);
  }

  Future<int> insertMedicine(Map<String, dynamic> row) async {
    Database db = await instance.database;
    print('>>>>>>>>stored medicine data in DB');

    return await db.insert(tableMedicine, row);
  }

  Future<int> insertLeisure(Map<String, dynamic> row) async {
    Database db = await instance.database;
    print('>>>>>>>>stored apps data in DB');

    return await db.insert(tableLeisure, row);
  }


  //Fetch Query
  Future<List<Map<String, dynamic>>> queryLetterSize() async {
    Database db = await instance.database;
    return await db.query(tableLetterSize);
  }

  Future<List<Map<String, dynamic>>> queryAllContacts() async {
    Database db = await instance.database;
    return await db.query(tableContacts);
  }

  Future<List<Map<String, dynamic>>> queryAllEmergencyContacts() async {
    Database db = await instance.database;
    return await db.query(tableEmergencyContacts);
  }

  Future<List<Map<String, dynamic>>> querySound() async {
    Database db = await instance.database;
    return await db.query(tableSound);
  }

  Future<List<Map<String, dynamic>>> queryAllMedicine() async {
    Database db = await instance.database;
    return await db.query(tableMedicine);
  }

  Future<List<Map<String, dynamic>>> queryAllLeisure() async {
    Database db = await instance.database;
    return await db.query(tableLeisure);
  }


  //Update Query
  Future<int> updateMedicine(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    print('>>>>>>>>>>>>Column ID: $id');
    return await db.update(tableMedicine, row, where: '$columnId = ?', whereArgs: [id]);
  }


  //Delete Query
  Future<int> deleteFavoriteContact(int index) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> contacts = await db.query(tableContacts);
    int idToDelete = contacts[index][columnId];
    return await db.delete(tableContacts, where: '$columnId = ?', whereArgs: [idToDelete]);
  }

  Future<int> deleteEmergencyContact(int index) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> contacts = await db.query(tableEmergencyContacts);
    int idToDelete = contacts[index][columnId];
    return await db.delete(tableEmergencyContacts, where: '$columnId = ?', whereArgs: [idToDelete]);
  }

  Future<int> deleteVolume() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> volume = await db.query(tableSound);
    int idToDelete = volume[0][columnId];
    return await db.delete(tableSound, where: '$columnId = ?', whereArgs: [idToDelete]);
  }

  Future<int> deleteBluetooth() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> bluetoothValue = await db.query(tableSound);
    int idToDelete = bluetoothValue[0][columnId];
    return await db.delete(tableSound, where: '$columnId = ?', whereArgs: [idToDelete]);
  }

  Future<int> deleteMedicine(int index) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> medicines = await db.query(tableMedicine);
      int idToDelete = medicines[index][columnId];
      return await db.delete(tableMedicine, where: '$columnId = ?', whereArgs: [idToDelete]);
  }


  //Clear Table Query
  Future<int> clearLetterSize() async {
    Database db = await instance.database;
    return await db.delete(tableLetterSize);
  }
  
  Future<int> clearContacts() async {
    Database db = await instance.database;
    return await db.delete(tableContacts);
  }

  Future<int> clearEmergencyContacts() async {
    Database db = await instance.database;
    return await db.delete(tableEmergencyContacts);
  }

  Future<int> clearSound() async {
    Database db = await instance.database;
    return await db.delete(tableSound);
  }

  Future<int> clearMedicine() async {
    Database db = await instance.database;
    return await db.delete(tableMedicine);
  }

  Future<int> clearLeisure() async {
    Database db = await instance.database;
    return await db.delete(tableLeisure);
  }

}