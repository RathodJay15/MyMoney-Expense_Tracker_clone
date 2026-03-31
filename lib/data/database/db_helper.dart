import 'package:mymoneyclone/core/constants/app_constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper obj = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), AppConstants.dbName);

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
      time TEXT
    )
    ''');

    await db.execute('''
    INSERT INTO categories (name, type, icon) VALUES
      ('Awards', 'INCOME', 'award'),
      ('Coupons', 'INCOME', 'ticket_discount'),
      ('Grants', 'INCOME', 'gift'),
      ('Lottery', 'INCOME', 'ticket_star'),
      ('Refunds', 'INCOME', 'money_recive'),
      ('Rental', 'INCOME', 'home_2'),
      ('Salary', 'INCOME', 'wallet_3'),
      ('Sale', 'INCOME', 'tag');
  ''');

    await db.execute('''
    INSERT INTO categories (name, type, icon) VALUES
      ('Baby', 'EXPENSE', 'happyemoji'),
      ('Beauty', 'EXPENSE', 'brush_2'),
      ('Bills', 'EXPENSE', 'receipt_item'),
      ('Car', 'EXPENSE', 'car'),
      ('Clothing', 'EXPENSE', 'shop'),
      ('Education', 'EXPENSE', 'teacher'),
      ('Electronics', 'EXPENSE', 'device_message'),
      ('Entertainment', 'EXPENSE', 'video_play'),
      ('Food', 'EXPENSE', 'milk'),
      ('Health', 'EXPENSE', 'heart'),
      ('Home', 'EXPENSE', 'home'),
      ('Insurance', 'EXPENSE', 'security_safe'),
      ('Shopping', 'EXPENSE', 'shopping_cart'),
      ('Social', 'EXPENSE', 'people'),
      ('Sport', 'EXPENSE', 'cup'),
      ('Tax', 'EXPENSE', 'receipt_edit'),
      ('Telephone', 'EXPENSE', 'call'),
      ('Transportation', 'EXPENSE', 'bus');
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