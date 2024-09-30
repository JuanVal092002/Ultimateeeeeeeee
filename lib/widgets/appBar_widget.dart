import 'package:flutter/material.dart';
import 'package:mesa_servicio_ctpi/controllers/profile_controller.dart';
import 'package:mesa_servicio_ctpi/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppbarWidget extends StatefulWidget {
  const AppbarWidget({super.key});

  @override
  State<AppbarWidget> createState() => _AppbarWidgetState();
}

@override
Size get preferredSize => const Size.fromHeight(kToolbarHeight);
class _AppbarWidgetState extends State<AppbarWidget> {

  String? _nombreUsuario;
  String? _fotoUsuario;
  String? _error;

  @override
     void initState() {
    super.initState();
    _loadUsuario();
  }
    Future<void> _loadUsuario() async {
    try {
      String? token = await _getToken();
      if (token != null) {
        Map<String, dynamic>? userProfile = await fetchUserProfile(token);

        if (userProfile != null) {
          setState(() {
            _nombreUsuario = userProfile['nombre']?.toString() ?? 'Usuario';
            _fotoUsuario = userProfile['foto']?.toString();
          });
        } else {
          setState(() {
            _error = 'Perfil de usuario no disponible';
          });
        }
      }
    } catch (e) {
      setState(() {
        _error = 'Error al cargar la información del usuario: $e';
      });
    }
  }
  
  // Obtener el token almacenado en SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            "assets/icons/chat.png",
            height: 60,
            width: 60,
            fit: BoxFit.contain,
          ),
        ),
        title: Text('Hola, ${_nombreUsuario ?? "Usuario"}',style: const TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),),
        actions: [
          Row(
            children: [
              if (_fotoUsuario != null && Uri.tryParse(_fotoUsuario!)?.isAbsolute == true)
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(_fotoUsuario!),
                    backgroundColor: Colors.green,
                  ),
                )
              else
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                  child: const CircleAvatar(
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ),
              IconButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
                icon: const Icon(
                  Icons.exit_to_app_rounded,
                  size: 35,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}