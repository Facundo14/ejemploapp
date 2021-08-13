import 'dart:async';

import 'package:ejemplo_app/data/dbase.dart';
import 'package:ejemplo_app/models/plato_model.dart';

class DataProvider {
  static final StreamController<List<PlatoModel>> _streamController =
      new StreamController.broadcast();

  static Stream<List<PlatoModel>> get streamController =>
      _streamController.stream;

  static void obtienePlatosProvider() async {
    final db = new Dbase();
    final lista = await db.obtienePlatos();
    _streamController.add(lista);
  }

  static dispose() {
    _streamController.close();
  }
}
