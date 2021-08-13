import 'dart:io';

import 'package:ejemplo_app/models/plato_model.dart';
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
    final path = join(documentsDirectory.path, 'base.db');
    print('=======================Base===================================');
    print(path);
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('''CREATE TABLE platos (
            Codigo TEXT,
            Descripcion TEXT, 
            Precio Double, PRIMARY KEY(Codigo)
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
}
