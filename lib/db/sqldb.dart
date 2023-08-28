import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await intialDb();
      return _db;
    } else {
      return _db;
    }
  }

  intialDb() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'aasa.db');
    Database mydb = await openDatabase(path, onCreate: _onCreate, version: 4, onUpgrade: _onUpgrade);
    return mydb;
  }

  _onUpgrade(Database db, int oldversion, int newversion) {
    print("onUpgrade =====================================");
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
  CREATE TABLE "add_cat" (
    "id" INTEGER  NOT NULL PRIMARY KEY  AUTOINCREMENT,
      
      "name" TEXT NOT NULL,
      "color" INTEGER  NOT NULL
    


  )
 ''');
    await db.execute('''
  CREATE TABLE "selected_cat" (
    "id" INTEGER  NOT NULL PRIMARY KEY  AUTOINCREMENT,
      
      "cat_id" TEXT NOT NULL

    


  )
 ''');
    await db.execute('''
  CREATE TABLE "add_unit" (
    "id" INTEGER  NOT NULL PRIMARY KEY  AUTOINCREMENT,
      
      "name" TEXT NOT NULL,
      "status" TEXT NOT NULL

    


  )
 ''');
    await db.execute('''
  CREATE TABLE "selected_unit" (
    "id" INTEGER  NOT NULL PRIMARY KEY  AUTOINCREMENT,
      
      "unit_id" TEXT NOT NULL

    


  )
 ''');

    await db.execute('''
  CREATE TABLE "add_product" (
    "id" INTEGER  NOT NULL PRIMARY KEY  ,
      "product_name" TEXT NOT NULL,
      "pro_cat" TEXT NOT NULL,
      "img" TEXT NOT NULL,
      "sku" TEXT NOT NULL,
      "barcode" TEXT NOT NULL,
       "sales_prise" TEXT NOT NULL,
      "unit" TEXT NOT NULL,
      "product_cost" TEXT NOT NULL

     
      
 


  )
 ''');
    await db.execute('''
  CREATE TABLE "user_status" (
    "id" INTEGER  NOT NULL PRIMARY KEY  ,
      "status" TEXT NOT NULL
   
     
      
 


  )
 ''');
    await db.execute('''
  CREATE TABLE "images" (
    "id" INTEGER  NOT NULL PRIMARY KEY  ,
      "img" TEXT NOT NULL
   
     
      
 


  )
 ''');
    await db.execute('''
  CREATE TABLE "update_name" (
    "id" INTEGER  NOT NULL PRIMARY KEY  ,
      "name" TEXT NOT NULL
   
     
      
 


  )
 ''');
    await db.execute('''
  CREATE TABLE "cart" (
    "id" INTEGER  NOT NULL PRIMARY KEY  ,
     "cart" TEXT NOT NULL,
       "date_time" TEXT NOT NULL,
       "item" TEXT NOT NULL,
       "price" TEXT NOT NULL
   
   
     
      
 


  )
 ''');
    await db.execute('''
  CREATE TABLE "active_cart" (
    "id" INTEGER  NOT NULL PRIMARY KEY  ,
     "cart_name" TEXT NOT NULL,
      "c_name" TEXT NOT NULL,
       "date_time" TEXT NOT NULL,
       "item" TEXT NOT NULL,
       "item_price" TEXT NOT NULL,
       "price" TEXT NOT NULL,
        "all_cart_id" TEXT NOT NULL,
         "cart_id" INTEGER NOT NULL,
         "status" INTEGER NOT NULL

   
   
     
      
 


  )
 ''');
    await db.execute('''
  CREATE TABLE "add_expense" (
    "id" INTEGER  NOT NULL PRIMARY KEY  ,
     "nominal" TEXT NOT NULL,
       "notes" TEXT NOT NULL,
       "p_lable" TEXT NOT NULL,
       "date_time" TEXT NOT NULL,
            "r_id" TEXT NOT NULL
   
   
     
      
 


  )
 ''');
    await db.execute('''
  CREATE TABLE "trance_action_expense" (
    "id" INTEGER  NOT NULL PRIMARY KEY  ,
     "date" TEXT NOT NULL,
       "r_id" TEXT NOT NULL,
       "note" TEXT NOT NULL,
        "sub_total" TEXT NOT NULL,
       "grand_total" TEXT NOT NULL,
       "payment" TEXT NOT NULL,
       "change" TEXT NOT NULL,
       "status" TEXT NOT NULL,
       "is_expense" TEXT NOT NULL,
        "is_revenue" TEXT NOT NULL,
       "expense" TEXT NOT NULL,
       "revenue" TEXT NOT NULL,
       "cost" INTEGER  NOT NULL
      
          
   
   
     
      
 


  )
 ''');
    await db.execute('''
  CREATE TABLE "all_cart" (
    "id" INTEGER  NOT NULL PRIMARY KEY  ,
     "cart_time" TEXT NOT NULL,
      "price" TEXT NOT NULL,
       "items" TEXT NOT NULL
      
   
   
     
      
 


  )
 ''');
    await db.execute('''
  CREATE TABLE "home" (
    "id" INTEGER  NOT NULL PRIMARY KEY  ,
     "status" TEXT NOT NULL
    
      
   
   
     
      
 


  )
 ''');

    print(" onCreate =====================================");
  }

  readData(String sql) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);
    return response;
  }

  insertData(String sql) async {
    Database? mydb = await db;

    int response = await mydb!.rawInsert(sql);
    return response;
  }

  updateData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  deleteData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }

  rawQuery(String sql, List<String> list) {}

  batch() {}

// SELECT
// DELETE
// UPDATE
// INSERT
}
