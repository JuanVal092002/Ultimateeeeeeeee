import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SolucionCasoController {
  Future<String?> enviarSolucionCaso({
    required String idSolicitud,
    required String descripcionSolucion,
    required String tipoCaso,
    required String tipoSolucion,
    XFile? evidencia,
  }) async {
    const String baseUrl = "https://backendnodeproyectomesaservicio.onrender.com/api"; // Reemplaza con tu URL
    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/solucionCaso/$idSolicitud'));

    final token = await _getToken(); // Método para obtener el token, similar al que tienes en la pantalla

    if (token == null) {
      throw Exception('Token de autenticación no disponible');
    }

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['descripcionSolucion'] = descripcionSolucion;
    request.fields['tipoCaso'] = tipoCaso;
    request.fields['tipoSolucion'] = tipoSolucion;

    if (evidencia != null) {
      request.files.add(await http.MultipartFile.fromPath('evidencia', evidencia.path));
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Caso actualizado correctamente');
        print(responseData);
        return responseData['message'];
      } else {
        print('Error al actualizar el caso: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error en la solicitud: $e');
      return null;
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
