import 'package:ejemplo_app/share_prefs/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:ejemplo_app/pages/pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new UserPreferences();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final pref = new UserPreferences();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: (pref.nombreUsuario == '') ? 'login' : 'home',
      routes: {
        'home': (_) => HomePage(),
        'login': (_) => LoginPage(),
        'registrar': (_) => RegistrarPage(),
        'mantenimiento': (_) => MantenimientoPage()
      },
    );
  }
}
