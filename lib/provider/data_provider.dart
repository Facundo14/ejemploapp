import 'dart:async';

import 'package:ejemplo_app/data/dbase.dart';
import 'package:ejemplo_app/models/plato_model.dart';
import 'package:ejemplo_app/models/user_model.dart';

class DataProvider {
  /// ---------------- PLATOS ---------------------------*/
  static final StreamController<List<PlatoModel>> _streamPlatosController =
      new StreamController.broadcast();

  static Stream<List<PlatoModel>> get streamPlatosController =>
      _streamPlatosController.stream;

  static void obtienePlatosProvider() async {
    final db = new Dbase();
    final listaPlatos = await db.obtienePlatos();
    _streamPlatosController.add(listaPlatos);
  }

  /// ---------------- USERS ---------------------------*/
  static final StreamController<List<UserModel>> _streamUsersController =
      new StreamController.broadcast();

  static Stream<List<UserModel>> get streamUsersController =>
      _streamUsersController.stream;

  static void obtieneUsersProvider() async {
    final db = new Dbase();
    final listaUsers = await db.obtieneUsers();
    _streamUsersController.add(listaUsers);
  }

  /// ---------------- CIERRES DE LOS STREAMS ---------------------------*/
  static dispose() {
    _streamPlatosController.close();
    _streamUsersController.close();
  }
}
