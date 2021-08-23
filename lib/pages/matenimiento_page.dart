import 'package:flutter/material.dart';
import 'dart:io';

import 'package:ejemplo_app/data/dbase.dart';
import 'package:ejemplo_app/models/plato_model.dart';
import 'package:ejemplo_app/provider/data_provider.dart';
import 'package:ejemplo_app/share_prefs/user_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ejemplo_app/ui/input_decorations.dart';

class MantenimientoPage extends StatefulWidget {
  @override
  _MantenimientoPageState createState() => _MantenimientoPageState();
}

class _MantenimientoPageState extends State<MantenimientoPage> {
  File? _image;
  bool f = true;

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
    final pref = new UserPreferences();
    final PlatoModel args =
        ModalRoute.of(context)!.settings.arguments as PlatoModel;
    if (f) {
      if (args.codigo != '') {
        setState(() {
          _codigoController.text = args.codigo;
          _descripcionController.text = args.descripcion;
          _precioController.text = args.precio.toString();
          _image = args.picture == null ? null : File(args.picture.toString());
        });
      }
      f = false;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Mantenimiento'),
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
                            width: 300,
                            height: 200,
                          )
                        : Image(image: AssetImage('images/no-image.png')),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: ElevatedButton(
                      child: Text('Selecciona una imagen'),
                      onPressed: _openImagePicker,
                    ),
                  ),
                ]),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: _codigoController,
                cursorColor: Theme.of(context).accentColor,
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Codigo',
                  labelText: 'Codigo',
                  prefixIcon: Icons.qr_code,
                ),
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
                controller: _descripcionController,
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Descripcion',
                    labelText: 'Descripcion',
                    prefixIcon: Icons.description),
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
                controller: _precioController,
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Precio',
                    labelText: 'Precio',
                    prefixIcon: Icons.money),
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
        onPressed: () {
          if (_keyFormMantenimiento.currentState!.validate()) {
            if (args.codigo != '') {
              final plato = new PlatoModel(
                  codigo: _codigoController.text,
                  descripcion: _descripcionController.text,
                  picture: _image == null ? null : _image?.path.toString(),
                  precio: double.parse(_precioController.text));
              db.modificaPlato(plato);
              DataProvider.obtienePlatosProvider();
              Navigator.pop(context);
            } else {
              final plato = new PlatoModel(
                  codigo: _codigoController.text,
                  descripcion: _descripcionController.text,
                  picture: _image?.path ?? null,
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
