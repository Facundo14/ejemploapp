import 'dart:io';

import 'package:ejemplo_app/models/plato_model.dart';
import 'package:ejemplo_app/models/user_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Dbase {
  static Database? _database;
  static final Dbase _db = new Dbase._();

  Dbase._();

  factory Dbase() {
    return _db;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await iniDB();
    return _database!;
  }

  Future<Database> iniDB() async {
    //Path donde esta la base de datos
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'base5.db');
    print('=======================Base===================================');
    print(path);
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('''CREATE TABLE platos (
            Codigo TEXT,
            Descripcion TEXT, 
            Picture TEXT, 
            Precio Double, PRIMARY KEY(Codigo)
            )''');
      db.execute('''CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            Nombre TEXT, 
            Email TEXT, 
            Password TEXT
            )''');
    });
  }

  Future<bool> guardaPlato(PlatoModel plato) async {
    final _plato = await leePlatoByCodigo(plato.codigo);
    if (_plato.codigo != '') {
      final res = await modificaPlato(plato);
      if (res > 0) return true;
    } else {
      final res = await agregaPlato(plato);
      if (res > 0) return true;
    }
    return false;
  }

  Future<int> modificaPlato(PlatoModel plato) async {
    int res = 0;
    try {
      final db = await database;
      res = await db.update('platos', plato.toJson(),
          where: 'Codigo = ?', whereArgs: [plato.codigo]);
    } catch (errorsql) {
      print(errorsql.toString());
    } finally {}
    return res;
  }

  Future<int> agregaPlato(PlatoModel plato) async {
    int res = 0;
    try {
      final db = await database;
      res = await db.insert('platos', plato.toJson());
    } catch (errorsql) {
      print(errorsql.toString());
    } finally {}
    return res;
  }

  Future<PlatoModel> leePlatoByCodigo(String codigo) async {
    PlatoModel plato = new PlatoModel(codigo: '', descripcion: '', precio: 0.0);
    try {
      final db = await database;
      final res =
          await db.query('platos', where: 'Codigo = ?', whereArgs: [codigo]);
      if (res.isNotEmpty) plato = PlatoModel.fromJson(res.first);
    } catch (errorsql) {
      print(errorsql.toString());
    } finally {}
    return plato;
  }

  Future<List<PlatoModel>> obtienePlatos() async {
    List<PlatoModel> lstPlatos = [];
    try {
      final db = await database;
      final res = await db.query('platos', orderBy: 'Descripcion');
      lstPlatos = (res.isNotEmpty)
          ? res.map((item) => PlatoModel.fromJson(item)).toList()
          : [];
    } catch (errorsql) {
      print(errorsql.toString());
    } finally {}
    return lstPlatos;
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<void> borrarPlato(String codigo) async {
    final db = await database;
    await db.delete('platos', where: 'Codigo = ?', whereArgs: [codigo]);
    print('Eliminado con exito');
  }

  /// ---------------------------------- LOGIN ---------------------------------- */

  Future<bool> guardaUser(UserModel user) async {
    final _user = await leeUserByCodigo(user.id!);
    if (_user.id != null) {
      final res = await modificaUser(user);
      if (res > 0) return true;
    } else {
      final res = await agregaUser(user);
      if (res > 0) return true;
    }
    return false;
  }

  Future<int> modificaUser(UserModel user) async {
    int res = 0;
    try {
      final db = await database;
      res = await db.update('users', user.toJson(),
          where: 'Codigo = ?', whereArgs: [user.id]);
    } catch (errorsql) {
      print(errorsql.toString());
    } finally {}
    return res;
  }

  Future<int> agregaUser(UserModel user) async {
    int res = 0;
    try {
      final db = await database;
      res = await db.insert('users', user.toJson());
    } catch (errorsql) {
      print(errorsql.toString());
    } finally {}
    return res;
  }

  Future<UserModel> leeUserByCodigo(int id) async {
    UserModel user = new UserModel(nombre: '', email: '', password: '');
    try {
      final db = await database;
      final res = await db.query('users', where: 'Id = ?', whereArgs: [id]);
      if (res.isNotEmpty) user = UserModel.fromJson(res.first);
    } catch (errorsql) {
      print(errorsql.toString());
    } finally {}
    return user;
  }

  Future<List<UserModel>> obtieneUsersLogin(String email) async {
    List<UserModel> lstUsers = [];
    try {
      final db = await database;
      final res =
          await db.query('users', where: 'Email = ?', whereArgs: [email]);
      lstUsers = (res.isNotEmpty)
          ? res.map((item) => UserModel.fromJson(item)).toList()
          : [];
    } catch (errorsql) {
      print(errorsql.toString());
    } finally {}
    return lstUsers;
  }

  Future<List<UserModel>> obtieneUsers() async {
    List<UserModel> lstUsers = [];
    try {
      final db = await database;
      final res = await db.query('users', orderBy: 'Nombre');
      lstUsers = (res.isNotEmpty)
          ? res.map((item) => UserModel.fromJson(item)).toList()
          : [];
    } catch (errorsql) {
      print(errorsql.toString());
    } finally {}
    return lstUsers;
  }
}
