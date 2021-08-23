import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:ejemplo_app/data/dbase.dart';
import 'package:ejemplo_app/models/plato_model.dart';
import 'package:ejemplo_app/provider/data_provider.dart';
import 'package:ejemplo_app/share_prefs/user_preferences.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pref = new UserPreferences();
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Platos'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              pref.nombreUsuario = '';
              Navigator.pushReplacementNamed(context, 'login');
            },
          )
        ],
      ),
      body: StreamBuilder(
          stream: DataProvider.streamPlatosController,
          // initialData: initialData,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Container());
            }
            final List<PlatoModel> lista = snapshot.data;
            return ListView.separated(
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                itemCount: lista.length,
                itemBuilder: (_, int index) {
                  return Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: _borradoDismiss(lista, index, context),
                        )
                      ],
                    ),
                  );
                });
          }),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            final PlatoModel lista2 =
                new PlatoModel(codigo: '', descripcion: '', precio: 0);
            Navigator.pushNamed(context, 'mantenimiento', arguments: lista2);
          }),
    );
  }
}

Dismissible _borradoDismiss(
    List<PlatoModel> lista, int index, BuildContext context) {
  return Dismissible(
    background: Container(
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              'Eliminar',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    ),
    direction: DismissDirection.startToEnd,
    key: Key(lista[index].codigo),
    onDismissed: (direction) {
      final db = new Dbase();
      db.borrarPlato(lista[index].codigo);
      DataProvider.obtienePlatosProvider();
    },
    confirmDismiss: (_) {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Eliminar plato'),
          content: Text(
            'Confirma la eliminacion?',
          ),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Si'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        ),
      );
    },
    child: _lista(lista, index, context),
  );
}

BounceInLeft _lista(List<PlatoModel> lista, int index, BuildContext context) {
  final item = lista[index];
  print('Esto es ${item.picture.toString()}');
  return BounceInLeft(
    delay: Duration(milliseconds: 200 * index),
    child: ListTile(
      leading: item.picture != null
          ? Image.file(File(item.picture.toString()))
          : Image(image: AssetImage('images/no-image.png')),
      title: Text(
        item.descripcion,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      trailing: Text('\$ ' + item.precio.toString(),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      onTap: () {
        Navigator.pushNamed(context, 'mantenimiento', arguments: item);
      },
    ),
  );
}
