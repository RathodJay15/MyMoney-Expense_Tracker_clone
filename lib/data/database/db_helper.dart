import 'package:mymoneyclone/core/constants/app_constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper obj = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(AppConstants.dbName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final path = join(await getDatabasesPath(), filePath);

    return await openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('PRAGMA foreign_keys = ON');

    await db.execute(''' 
    CREATE TABLE ${AppConstants.accountTable}(
    accountId INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    balance REAL,
    icon TEXT
    )    
    ''');

    await db.execute(''' 
    CREATE TABLE ${AppConstants.categoryTable}(
    categoryId INTEGER PRIMARY KEY AUTOINCREMENT,
    type TEXT,
    name TEXT,
    icon TEXT
    )    
    ''');

    await db.execute('''
    CREATE TABLE ${AppConstants.recordTable} (
      recordId INTEGER PRIMARY KEY AUTOINCREMENT,
      type TEXT,
      account INTEGER,
      category INTEGER,
      note TEXT,
      amount REAL,
      date TEXT,
      time TEXT,
    )
    ''');
  }
}
    // await db.execute('''
    // CREATE TABLE ${AppConstants.recordTable} (
    //   recordId INTEGER PRIMARY KEY AUTOINCREMENT,
    //   type TEXT,
    //   account INTEGER,
    //   category INTEGER,
    //   note TEXT,
    //   amount REAL,
    //   date TEXT,
    //   time TEXT,
    //   FOREIGN KEY (account) REFERENCES accounts (accountId) 
    //     ON DELETE CASCADE 
    //     ON UPDATE NO ACTION,
    //   FOREIGN KEY (category) REFERENCES categories (categoryId) 
    //     ON DELETE CASCADE 
    //     ON UPDATE NO ACTION
    // )
    // ''');