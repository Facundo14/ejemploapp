import 'dart:io';

import 'package:ejemplo_app/data/dbase.dart';
import 'package:ejemplo_app/models/plato_model.dart';
import 'package:ejemplo_app/provider/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MantenimientoPage extends StatefulWidget {
  @override
  _MantenimientoPageState createState() => _MantenimientoPageState();
}

class _MantenimientoPageState extends State<MantenimientoPage> {
  File? _image;

  final picker = ImagePicker();
  // Implementing the image picker
  Future<void> _openImagePicker() async {
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  final db = new Dbase();

  final _codigoController = new TextEditingController();
  final _descripcionController = new TextEditingController();
  final _precioController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mantenimiento')),
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              decoration: InputDecoration(labelText: 'Codigo'),
              controller: _codigoController,
              cursorColor: Theme.of(context).accentColor,
              // maxLength: 6,
            ),
          ),
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              decoration: InputDecoration(labelText: 'Descripcion'),
              controller: _descripcionController,
              cursorColor: Theme.of(context).accentColor,
              // maxLength: 6,
            ),
          ),
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              decoration: InputDecoration(labelText: 'Precio'),
              controller: _precioController,
              cursorColor: Theme.of(context).accentColor,
              // maxLength: 6,
            ),
          ),
          SizedBox(height: 20),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(35),
              child: Column(children: [
                Center(
                  child: ElevatedButton(
                    child: Text('Select An Image'),
                    onPressed: _openImagePicker,
                  ),
                ),
                SizedBox(height: 35),
                Container(
                  alignment: Alignment.center,
                  width: 100,
                  height: 100,
                  color: Colors.grey[300],
                  child: _image != null
                      ? Image.file(_image!, fit: BoxFit.cover)
                      : Text('Please select an image'),
                )
              ]),
            ),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () async {
          final plato = new PlatoModel(
              codigo: _codigoController.text,
              descripcion: _descripcionController.text,
              picture: _image!.path.toString(),
              precio: double.parse(_precioController.text));
          db.agregaPlato(plato);
          DataProvider.obtienePlatosProvider();
          Navigator.pop(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
