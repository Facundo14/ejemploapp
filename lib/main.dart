import 'package:flutter/material.dart';
import 'package:ejemplo_app/pages/pages.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'home',
      routes: {
        'home': (_) => HomePage(),
        'login': (_) => LoginPage(),
        'registrar': (_) => RegistrarPage(),
        'mantenimiento': (_) => MantenimientoPage()
      },
    );
  }
}
