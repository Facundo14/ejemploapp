import 'package:ejemplo_app/ui/input_decorations.dart';
import 'package:flutter/material.dart';

class PassInput extends StatelessWidget {
  const PassInput({
    Key? key,
    required TextEditingController userPasswordController,
  })  : _userPasswordController = userPasswordController,
        super(key: key);

  final TextEditingController _userPasswordController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
    );
  }
}
