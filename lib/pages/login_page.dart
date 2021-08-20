import 'package:ejemplo_app/provider/data_provider.dart';
import 'package:ejemplo_app/ui/input_decorations.dart';
import 'package:ejemplo_app/widgets/auth_background.dart';
import 'package:ejemplo_app/widgets/card_container.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackground(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 250,
            ),
            CardContainer(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Ingreso',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    children: [_LoginForm()],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, 'registrar'),
              style: ButtonStyle(
                  overlayColor:
                      MaterialStateProperty.all(Colors.blue.withOpacity(0.1)),
                  shape: MaterialStateProperty.all(StadiumBorder())),
              child: Text(
                'Crear una nueva cuenta',
                style: TextStyle(fontSize: 15, color: Colors.black87),
              ),
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    ));
  }
}

class _LoginForm extends StatelessWidget {
  final _userEmailController = new TextEditingController();
  final _userPasswordController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DataProvider.streamUsersController,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return _Formulario(
            formKey: _formKey,
            userEmailController: _userEmailController,
            userPasswordController: _userPasswordController);
      },
    );
  }
}

class _Formulario extends StatelessWidget {
  const _Formulario({
    Key? key,
    required GlobalKey<FormState> formKey,
    required TextEditingController userEmailController,
    required TextEditingController userPasswordController,
  })  : _formKey = formKey,
        _userEmailController = userEmailController,
        _userPasswordController = userPasswordController,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final TextEditingController _userEmailController;
  final TextEditingController _userPasswordController;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              controller: _userEmailController,
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
              controller: _userPasswordController,
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
            _BotonIngreso(
                formKey: _formKey,
                userEmailController: _userEmailController,
                userPasswordController: _userPasswordController)
          ],
        ),
      ),
    );
  }
}

class _BotonIngreso extends StatelessWidget {
  const _BotonIngreso({
    Key? key,
    required GlobalKey<FormState> formKey,
    required TextEditingController userEmailController,
    required TextEditingController userPasswordController,
  })  : _formKey = formKey,
        _userEmailController = userEmailController,
        _userPasswordController = userPasswordController,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final TextEditingController _userEmailController;
  final TextEditingController _userPasswordController;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        disabledColor: Colors.grey,
        elevation: 0,
        color: Colors.blue,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
          child: Text(
            'Ingresar',
            style: TextStyle(color: Colors.white),
          ),
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            DataProvider.obtieneUsersProvider(
                _userEmailController.text, _userPasswordController.text);
            final res = await DataProvider.streamUsersController.first;
            //print(res);

            if (res.email == _userEmailController.text &&
                res.password == _userPasswordController.text) {
              Navigator.pushNamed(context, 'home');
            } else {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(
                    'Error!',
                    style: TextStyle(color: Colors.red),
                  ),
                  content: Text(
                    'Por favor revisa los datos',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Aceptar"),
                    ),
                  ],
                ),
              );
            }
          }
        });
  }
}
