import 'dart:convert';
import 'package:http/http.dart' as http;


Future<Map<String, dynamic>> fetchUserProfile(String token) async {
    final response = await http.get(
      Uri.parse('https://backendnodeproyectomesaservicio.onrender.com/api/usuarios/perfil'), 
      headers: {
        'Authorization': 'Bearer $token', 
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      throw Exception('Failed to load user profile');
    }
}

Future<Map<String, dynamic>> fetchUser(String token, String id) async {
  final url = Uri.parse('https://backendnodeproyectomesaservicio.onrender.com/api/usuarios/$id');
  // Realiza la solicitud GET
  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
    },
  );
  // Verifica el estado de la respuesta
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    // Verifica si 'data' está presente en la respuesta
    if (data.containsKey('data')) {
      return data['data'];
    } else {
      throw Exception('Data field missing in response');
    }
  } else {
    throw Exception('Failed to load user: ${response.reasonPhrase}');
  }
}
