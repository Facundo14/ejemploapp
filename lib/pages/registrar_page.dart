import 'package:ejemplo_app/data/dbase.dart';
import 'package:ejemplo_app/models/plato_model.dart';
import 'package:ejemplo_app/models/user_model.dart';
import 'package:ejemplo_app/provider/data_provider.dart';
import 'package:ejemplo_app/ui/input_decorations.dart';
import 'package:flutter/material.dart';

class RegistrarPage extends StatefulWidget {
  @override
  _RegistrarPageState createState() => _RegistrarPageState();
}

class _RegistrarPageState extends State<RegistrarPage> {
  final db = new Dbase();

  final _codigoController = new TextEditingController();
  final _nombreController = new TextEditingController();
  final _emailController = new TextEditingController();
  final _passwordController = new TextEditingController();

  @override
  void initState() {
    _codigoController.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Registro!')),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          _LoginForm(
              emailController: _emailController,
              nombreController: _nombreController,
              passwordController: _passwordController),
          SizedBox(height: 20),
          MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Text('Guardar', style: TextStyle(color: Colors.white)),
              onPressed: () {
                final user = new UserModel(
                    nombre: _nombreController.text,
                    email: _emailController.text,
                    password: _passwordController.text);
                db.agregaUser(user);
                DataProvider.obtieneUsersProvider();
                print(DataProvider.streamUsersController.first);
                Navigator.pushNamed(context, 'login');
              },
              color: Colors.blue),
        ]));
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    Key? key,
    required TextEditingController emailController,
    required TextEditingController nombreController,
    required TextEditingController passwordController,
  })  : _emailController = emailController,
        _nombreController = nombreController,
        _passwordController = passwordController,
        super(key: key);

  final TextEditingController _nombreController;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DataProvider.streamUsersController,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _nombreController,
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  decoration: InputDecorations.authInputDecoration(
                      hintText: 'Nombre',
                      labelText: 'Nombre',
                      prefixIcon: Icons.people),
                  validator: (value) {
                    return (value != null && value.length >= 6)
                        ? null
                        : 'La contraseña debe de ser de 6 cracteres';
                  },
                ),
                SizedBox(height: 30),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _emailController,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecorations.authInputDecoration(
                      hintText: 'Email',
                      labelText: 'Email',
                      prefixIcon: Icons.alternate_email_sharp),
                  validator: (value) {
                    String pattern =
                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                    RegExp regExp = new RegExp(pattern);

                    return regExp.hasMatch(value ?? '')
                        ? null
                        : 'El valor no es un correo';
                  },
                ),
                SizedBox(height: 30),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _passwordController,
                  autocorrect: false,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecorations.authInputDecoration(
                      hintText: 'Contraseña',
                      labelText: 'Contraseña',
                      prefixIcon: Icons.lock),
                  validator: (value) {
                    return (value != null && value.length >= 6)
                        ? null
                        : 'La contraseña debe de ser de 6 cracteres';
                  },
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }
}
