import 'package:ejemplo_app/ui/input_decorations.dart';
import 'package:flutter/material.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({
    Key? key,
    required TextEditingController userEmailController,
  })  : _userEmailController = userEmailController,
        super(key: key);

  final TextEditingController _userEmailController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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

        return regExp.hasMatch(value ?? '') ? null : 'El valor no es un correo';
      },
    );
  }
}
