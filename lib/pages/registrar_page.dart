import 'package:flutter/material.dart';
import 'package:ejemplo_app/data/dbase.dart';
import 'package:ejemplo_app/models/user_model.dart';
import 'package:ejemplo_app/provider/data_provider.dart';
import 'package:ejemplo_app/ui/input_decorations.dart';

class RegistrarPage extends StatelessWidget {
  final db = new Dbase();

  //final _codigoController = new TextEditingController();
  final _nombreController = new TextEditingController();
  final _emailController = new TextEditingController();
  final _passwordController = new TextEditingController();
  final _formKeyCreate = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Registro'),
          centerTitle: true,
        ),
        body: _Body(
            emailController: _emailController,
            nombreController: _nombreController,
            passwordController: _passwordController,
            formKeyCreate: _formKeyCreate,
            db: db));
  }
}

class _Body extends StatelessWidget {
  const _Body({
    Key? key,
    required TextEditingController emailController,
    required TextEditingController nombreController,
    required TextEditingController passwordController,
    required GlobalKey<FormState> formKeyCreate,
    required this.db,
  })  : _emailController = emailController,
        _nombreController = nombreController,
        _passwordController = passwordController,
        _formKeyCreate = formKeyCreate,
        super(key: key);

  final TextEditingController _emailController;
  final TextEditingController _nombreController;
  final TextEditingController _passwordController;
  final GlobalKey<FormState> _formKeyCreate;
  final Dbase db;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          _LoginForm(
            emailController: _emailController,
            nombreController: _nombreController,
            passwordController: _passwordController,
            formKeyCreate: _formKeyCreate,
          ),
          SizedBox(height: 20),
          MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Text('Guardar', style: TextStyle(color: Colors.white)),
              onPressed: () {
                if (_formKeyCreate.currentState!.validate()) {
                  final user = new UserModel(
                      nombre: _nombreController.text,
                      email: _emailController.text,
                      password: _passwordController.text);
                  db.agregaUser(user);
                  DataProvider.obtieneUsersProvider(
                      _emailController.text, _passwordController.text);
                  final res = DataProvider.streamUsersController.first;
                  print(res);

                  Navigator.pushNamed(context, 'login');
                }
              },
              color: Colors.blue),
        ]),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    Key? key,
    required GlobalKey<FormState> formKeyCreate,
    required TextEditingController emailController,
    required TextEditingController nombreController,
    required TextEditingController passwordController,
  })  : _emailController = emailController,
        _nombreController = nombreController,
        _passwordController = passwordController,
        _formKeyCreate = formKeyCreate,
        super(key: key);

  final TextEditingController _nombreController;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;
  final GlobalKey<FormState> _formKeyCreate;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DataProvider.streamUsersController,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          child: Form(
            key: _formKeyCreate,
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
                    return (value != null && value.length >= 3)
                        ? null
                        : 'El nombre debe de ser de 3 cracteres o mas';
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
