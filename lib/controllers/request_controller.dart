import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mesa_servicio_ctpi/models/solicitud_model.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<dynamic>> fetchSolicitudes() async {
  final response = await http.get(Uri.parse('https://backendnodeproyectomesaservicio.onrender.com/api/solicitud'));

  if (response.statusCode == 200) {
    return jsonDecode(response.body)['data'];
  } else {
    throw Exception('Failed to load solicitudes');
  }
}

class RequestAssignedController {
  final String url = 'https://backendnodeproyectomesaservicio.onrender.com/api/solicitud/asignadas';  

  // Método para obtener las solicitudes asignadas
  Future<List<dynamic>> getAssignedRequests() async {
    try {
      // Obtener el token del almacenamiento local
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token'); // Usa la clave correcta

      if (token == null) {
        throw Exception("Token no encontrado");
      }

      // Hacer la solicitud GET con el token de autenticación
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Convertir el cuerpo de la respuesta en JSON
        final jsonResponse = json.decode(response.body);

        // Verificar si 'solicitudesAsignadas' existe y es una lista
        if (jsonResponse != null && jsonResponse['solicitudesAsignadas'] is List<dynamic>) {
          return jsonResponse['solicitudesAsignadas'] as List<dynamic>;
        } else {
          print('La clave "solicitudesAsignadas" no está presente o no es una lista');
          return [];
        }
      } else {
        throw Exception('Error al obtener las solicitudes asignadas');
      }
    } catch (e) {
      print('Error: $e');
      return []; // Retornar lista vacía en caso de error
    }
  }
}

class RequestController {
  Future<String?> crearSolicitud({
    required String ambiente,
    required String descripcion,
    required String telefono,
    XFile? foto,
  }) async {
    const String url = 'https://backendnodeproyectomesaservicio.onrender.com/api/solicitud';
    final request = http.MultipartRequest('POST', Uri.parse(url));

    final token = await _getToken();

    if (token == null) {
      print('Token de autenticación no disponible');
    }

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['ambiente'] = ambiente;
    request.fields['descripcion'] = descripcion;
    request.fields['telefono'] = telefono;

    // Agregar archivo, si existe
    if (foto != null) {
      try {
        request.files.add(await http.MultipartFile.fromPath('foto', foto.path));
      } catch (e) {
        print('Error al agregar la foto: $e');
      }
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // Log de la respuesta para debug
      print('Respuesta del servidor: ${response.body}');

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print('Solicitud creada con éxito');
        return responseData['message'];
      } else {
        print('Error al crear solicitud: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error al enviar la solicitud: $e');
    }
    return null;
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}

class RequestInformeController {
  final String baseUrl = 'https://backendnodeproyectomesaservicio.onrender.com/api/solicitud/';

  Future<Solicitud> getInformeRequests(String id) async {
    try {
      // Obtener el token del almacenamiento local
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception("Token no encontrado");
      }

      // Crear la URL completa con el ID
      final String url = '$baseUrl$id';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final solicitudData = jsonData['data']; // Acceder al campo "data"

        print(jsonData);
        
        if (solicitudData == null) {
          throw Exception('Solicitud no encontrada en la respuesta');
        }
        
        return Solicitud.fromJson(solicitudData);
      } else {
        throw Exception('Error al obtener solicitud: ${response.statusCode}');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Error de conexión: ${e.message}');
      } else {
        throw Exception('Error desconocido: $e');
      }
    }
  }
}