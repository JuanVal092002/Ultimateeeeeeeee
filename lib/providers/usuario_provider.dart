import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mesa_servicio_ctpi/models/usuario_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Asegúrate de que UserProvider extienda ChangeNotifier
class UserProvider extends ChangeNotifier {
  Usuario? _usuario;

  // Getter para obtener el usuario
  Usuario? get usuario => _usuario;

  // Método para cargar la información del usuario
  Future<void> loadUsuario() async {
    try {
      String? token = await _getToken();

      if (token != null) {
        final response = await http.get(
          Uri.parse('https://backendnodeproyectomesaservicio.onrender.com/api/usuarios/perfil'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonData = json.decode(response.body);
          if (jsonData['data'] != null) {
            // Asegúrate de que 'data' sea un mapa JSON
            final usuarioData = jsonData['data'] as Map<String, dynamic>;
            _usuario = Usuario.fromJson(usuarioData);
            notifyListeners(); // Notifica a los listeners cuando cambia el estado
          } else {
            throw Exception('Datos del usuario no encontrados');
          }
        } else {
          throw Exception('Error al obtener el perfil del usuario');
        }
      } else {
        throw Exception('Token no encontrado');
      }
    } catch (e) {
      print('Error al cargar la información del usuario: $e');
    }
  }

  // Método privado para obtener el token almacenado
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
