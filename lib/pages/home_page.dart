import 'dart:io';

import 'package:ejemplo_app/data/dbase.dart';
import 'package:ejemplo_app/models/plato_model.dart';
import 'package:ejemplo_app/provider/data_provider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final db = new Dbase();
  @override
  void initState() {
    DataProvider.obtienePlatosProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista'),
      ),
      body: StreamBuilder(
          stream: DataProvider.streamPlatosController,
          // initialData: initialData,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            final List<PlatoModel> lista = snapshot.data;
            return ListView.builder(
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
      child: _lista(lista, index),
    );
  }

  ListTile _lista(List<PlatoModel> lista, int index) {
    return ListTile(
      leading: Image.file(File(lista[index].picture.toString())),
      title: Text(
        lista[index].descripcion,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      trailing: Text('\$ ' + lista[index].precio.toString(),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      onTap: () {
        Navigator.pushNamed(context, 'mantenimiento', arguments: lista[index]);
      },
    );
  }
}
