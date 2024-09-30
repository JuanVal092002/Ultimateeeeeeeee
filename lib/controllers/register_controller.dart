import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterUsers {
  final String _baseUrl = 'https://backendnodeproyectomesaservicio.onrender.com/api/auth';

  Future<Map<String, dynamic>> registerUser({
    required String nombre,
    required String correo,
    required String rol,
    required String telefono,
    required String password,
    required String confirmPassword,
  }) async {
    final url = Uri.parse('$_baseUrl/register');

    // Verificar si las contraseñas coinciden
    if (password != confirmPassword) {
      return {'success': false, 'message': 'Las contraseñas no coinciden'};
    }

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombre': nombre,
          'correo': correo,
          'rol': rol,
          'telefono': telefono,
          'password': password,
          'confirmPassword': confirmPassword,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'],
          'data': data['data'],
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Error desconocido',
        };
      }
    } catch (error) {
      return {
        'success': false,
        'message': 'Error de conexión o problema inesperado: $error',
      };
    }
  }
}
