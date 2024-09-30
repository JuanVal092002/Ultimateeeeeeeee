import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mesa_servicio_ctpi/controllers/profile_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Map<String, dynamic>> _userProfile;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  void _loadUserProfile() async {
    String? token = await _getToken();
    if (token != null) {
      setState(() {
        _userProfile = fetchUserProfile(token);
      });
    } else {
      // Maneja el caso cuando el token no está disponible
      print('Token no encontrado');
      setState(() {
        _userProfile = Future.error('Token no encontrado');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _userProfile,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData) {
              return const Text('No data found');
            } else {
              final data = snapshot.data!;
              return buildProfile(data);
            }
          },
        ),
      ),
    );
  }

  Widget buildProfile(Map<String, dynamic> data) {
    return Container(
      height: 450,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(222, 217, 217, 1),
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                ],
              ),
            ),
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(
                data['foto']?['url'] ?? 'assets/icons/chat.png',
              ),
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(height: 20),
            Text(
              data['nombre'] ?? 'Nombre no disponible',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'CORREO',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(data['correo'] ?? 'Correo no disponible'),
            ),
            const SizedBox(height: 20),
            const Text(
              'ROL',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(data['rol'] ?? 'Rol no disponible'),
            ),
            const SizedBox(height: 20),
            const Text(
              'TELEFONO',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(data['telefono'] ?? 'Telefono no disponible'),
            ),
          ],
        ),
      ),
    );
  }
}
