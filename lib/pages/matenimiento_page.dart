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
        print('entro');
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
  final _keyFormMantenimiento = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final PlatoModel args =
        ModalRoute.of(context)!.settings.arguments as PlatoModel;
    if (args.codigo != '') {
      setState(() {
        _codigoController.text = args.codigo;
        _descripcionController.text = args.descripcion;
        _precioController.text = args.precio.toString();
        _image = File(args.picture.toString());
      });
    }
    return Scaffold(
      appBar: AppBar(title: Text('Mantenimiento')),
      body: SingleChildScrollView(
        child: Form(
          key: _keyFormMantenimiento,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.all(35),
                child: Column(children: [
                  Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey[300],
                    child: _image != null
                        ? Image.file(
                            _image!,
                            width: double.infinity,
                            height: 200,
                          )
                        : Text('Please select an image'),
                  ),
                  SizedBox(height: 35),
                  Center(
                    child: ElevatedButton(
                      child: Text('Select An Image'),
                      onPressed: _openImagePicker,
                    ),
                  ),
                ]),
              ),
            ),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Codigo'),
                controller: _codigoController,
                cursorColor: Theme.of(context).accentColor,
                validator: (value) {
                  return (value != null && value.length >= 3)
                      ? null
                      : 'El Codigo debe de ser mayor a 3 caracteres';
                },
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
                validator: (value) {
                  return (value != null && value.length >= 6)
                      ? null
                      : 'La Descripcion debe de ser mayor a 6 caracteres';
                },
                // maxLength: 6,
              ),
            ),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Precio'),
                controller: _precioController,
                cursorColor: Theme.of(context).accentColor,
                validator: (value) {
                  return (value != null && value.length >= 3)
                      ? null
                      : 'La Codigo debe de ser mayor a 3 caracteres';
                },
                // maxLength: 6,
              ),
            ),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () async {
          if (_keyFormMantenimiento.currentState!.validate()) {
            if (args.codigo != '') {
              final plato = new PlatoModel(
                  codigo: _codigoController.text,
                  descripcion: _descripcionController.text,
                  picture: _image!.path.toString(),
                  precio: double.parse(_precioController.text));
              db.modificaPlato(plato);
              DataProvider.obtienePlatosProvider();
              Navigator.pop(context);
            } else {
              final plato = new PlatoModel(
                  codigo: _codigoController.text,
                  descripcion: _descripcionController.text,
                  picture: _image!.path.toString(),
                  precio: double.parse(_precioController.text));
              db.agregaPlato(plato);
              DataProvider.obtienePlatosProvider();
              Navigator.pop(context);
            }
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
