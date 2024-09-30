import 'package:flutter/material.dart';
import 'package:mesa_servicio_ctpi/screens/form_request_screen.dart';
import 'package:mesa_servicio_ctpi/screens/home_funcionario_screen.dart';
import 'package:mesa_servicio_ctpi/screens/home_tecnico_screen.dart';
import 'package:mesa_servicio_ctpi/screens/informe_request_screen.dart';
import 'package:mesa_servicio_ctpi/screens/login_screen.dart';
import 'package:mesa_servicio_ctpi/screens/profile_screen.dart';
import 'package:mesa_servicio_ctpi/screens/register_screen.dart';
import 'package:path/path.dart';


Map<String, WidgetBuilder> MainRoute() {
  return {
    '/login': (context) => const LoginScreen(),
    '/register': (context) => const RegisterScreen(),
    '/homeofficial': (context) =>   const HomeOfficerScreen(),
    '/hometechnician': (context) => const HomeTechnicianScreen(),
    '/profile': (context) => const ProfileScreen(),
    '/solution': (context) => FormRequestScreen(idSolicitud: ModalRoute.of(context)!.settings.arguments as String),
    '/informe':(context)=>InformeRequestScreen(solicitudId: ModalRoute.of(context)!.settings.arguments as String)
  };
}

