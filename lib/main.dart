import 'package:flutter/material.dart';
import 'package:mesa_servicio_ctpi/providers/usuario_provider.dart';
import 'package:mesa_servicio_ctpi/routes/main_route.dart';
import 'package:mesa_servicio_ctpi/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(), // Asegúrate de que el nombre sea correcto
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WelcomeScreen(),
      routes: MainRoute(), // Asegúrate de que 'MainRoute' devuelva un Map<String, WidgetBuilder>
    );
  }
}
