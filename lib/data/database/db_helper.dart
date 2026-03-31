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
    icon TEXT,
    ignore INTEGER NOT NULL CHECK (ignore IN (0, 1))
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
    INSERT INTO categories (name, type, icon, ignore) VALUES
      ('Awards', 'INCOME', 'award',0),
      ('Coupons', 'INCOME', 'ticket_discount',0),
      ('Grants', 'INCOME', 'gift',0),
      ('Lottery', 'INCOME', 'ticket_star',0),
      ('Refunds', 'INCOME', 'money_recive',0),
      ('Rental', 'INCOME', 'home_2',0),
      ('Salary', 'INCOME', 'wallet_3',0),
      ('Sale', 'INCOME', 'tag',0);
  ''');

    await db.execute('''
    INSERT INTO categories (name, type, icon, ignore) VALUES
      ('Baby', 'EXPENSE', 'happyemoji',0),
      ('Beauty', 'EXPENSE', 'brush_2',0),
      ('Bills', 'EXPENSE', 'receipt_item',0),
      ('Car', 'EXPENSE', 'car',0),
      ('Clothing', 'EXPENSE', 'shop',0),
      ('Education', 'EXPENSE', 'teacher',0),
      ('Electronics', 'EXPENSE', 'device_message',0),
      ('Entertainment', 'EXPENSE', 'video_play',0),
      ('Food', 'EXPENSE', 'milk',0),
      ('Health', 'EXPENSE', 'heart',0),
      ('Home', 'EXPENSE', 'home',0),
      ('Insurance', 'EXPENSE', 'security_safe',0),
      ('Shopping', 'EXPENSE', 'shopping_cart',0),
      ('Social', 'EXPENSE', 'people',0),
      ('Sport', 'EXPENSE', 'cup',0),
      ('Tax', 'EXPENSE', 'receipt_edit',0),
      ('Telephone', 'EXPENSE', 'call',0),
      ('Transportation', 'EXPENSE', 'bus',0);
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