
import 'package:apicalls/model/passenger_data.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {

  static DatabaseHelper _databaseHelper;    // Singleton DatabaseHelper
  static Database _database;                // Singleton Database

  String PasengerTable = 'PasengerTable';
  String colname = 'name';
  String coltrips = 'trips';


  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {

    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {

    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'passengerss.db';

    // Open/create the database at a given path
    var ProductsDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return ProductsDatabase;
  }

  void _createDb(Database db, int newVersion) async {

    await db.execute('CREATE TABLE $PasengerTable('
        ' $colname TEXT, '
        '$coltrips INTEGER)');
  }

  // Fetch Operation: Get all data objects from database
  Future<List<Map<String, dynamic>>> getPassengerMapList() async {
    Database db = await this.database;
    var result = await db.query(PasengerTable);
    return result;
  }

  Future<List<Passenger>> getPassengerList() async {
    var PassengerMapList = await getPassengerMapList(); // Get 'Map List' from database
    int count = PassengerMapList.length; // Count the number of map entries in db table
    List<Passenger> ProductList = [];
    for (int i = 0; i < count; i++) {
      ProductList.add(Passenger.fromMapObject(PassengerMapList[i]));
    }
    return ProductList;
  }
  // Insert a data object to local database
  Future<int> insertPassenger(Passenger Product) async {
    Database db = await this.database;
    var result = await db.insert(PasengerTable, Product.toMap());
    return result;
  }

}








