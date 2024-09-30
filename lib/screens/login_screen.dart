import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mesa_servicio_ctpi/widgets/forgot_modal_widget.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var _obscureText = true;
  bool _isLoading = false;

  // Guardar el token en SharedPreferences
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  void handleLoginSuccess(String role) {
    if (role == 'tecnico') {
      Navigator.pushReplacementNamed(context, '/hometechnician');
    } else if (role == 'funcionario') {
      Navigator.pushReplacementNamed(context, '/homeofficial');
    }
  }

  // Función para realizar el login
  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      final correo = _emailController.text;
      final password = _passwordController.text;

      try {
        final response = await http.post(
          Uri.parse('https://backendnodeproyectomesaservicio.onrender.com/api/auth/login'), // Cambia la URL por la de tu backend
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'correo': correo, 'password': password}),
        );

        if (response.statusCode == 200 && response.body.isNotEmpty) {
          final data = json.decode(response.body);
          if (data.containsKey('dataUser') && data['dataUser'].containsKey('token')) {
            final String token = data['dataUser']['token'];
            final String role = data['dataUser']['user']['rol'];

            await _saveToken(token); // Guardar el token

            handleLoginSuccess(role); // Redirigir basado en el rol
          } else {
            // Manejar el caso donde la estructura JSON no es la esperada
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error en la respuesta del servidor.')),
            );
          }
        } else {
          // Manejo de errores, por ejemplo, credenciales incorrectas
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${response.body}')),
          );
        }
      } catch (e) {
        String errorMessage = 'Error desconocido';
        if (e is SocketException) {
          errorMessage = 'No hay conexión a Internet.';
        } else if (e is TimeoutException) {
          errorMessage = 'El tiempo de conexión ha expirado.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $errorMessage')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 150,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/icons/chat.png",
                  height: 218,
                  width: 206,
                  fit: BoxFit.contain,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'MI ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(57, 169, 0, 1),
                      ),
                    ),
                    Text(
                      'AYUDA ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'TICS ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(57, 169, 0, 1),
                      ),
                    ),
                  ],
                ),
                const Text(
                  'Regional Cauca',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 440),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(222, 217, 217, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'INICIO DE SESIÓN',
                            style: TextStyle(
                              color: Color.fromRGBO(57, 169, 0, 1),
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 18.0),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color.fromRGBO(255, 254, 254, 1),
                              hintStyle: const TextStyle(fontSize: 15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(255, 254, 254, 1),
                                  width: 2.0,
                                ),
                              ),
                              labelText: 'Correo electrónico',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ingresa tu correo electrónico';
                              }
                              if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value)) {
                                return 'Correo electrónico inválido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color.fromRGBO(255, 254, 254, 1),
                              labelText: 'Contraseña',
                              hintStyle: const TextStyle(fontSize: 15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(255, 254, 254, 1),
                                  width: 2.0,
                                ),
                              ),
                              errorStyle: const TextStyle(
                                color: Colors.red,
                                fontStyle: FontStyle.italic,
                                fontSize: 14.0,
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                child: Icon(
                                  _obscureText
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: const Color.fromRGBO(53, 74, 106, 1),
                                ),
                              ),
                            ),
                            obscureText: _obscureText,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ingresa tu contraseña';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 32.0),
                          ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              elevation: 2,
                              foregroundColor: Colors.white,
                              backgroundColor: const Color.fromRGBO(0, 50, 77, 1),
                              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text('Ingresar'),
                          ),
                          const SizedBox(height: 16.0),
                         Container(
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                return const ForgotModalWidget(); // Mostrar el widget ForgotModalWidget
                              },
                            );
                          },
                          child: const Text(
                            "¿Olvidaste tu contraseña?",
                            style: TextStyle(
                              color: Color.fromRGBO(57, 169, 0, 1),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                          children: [
                              const Text(
                                "¿No tienes una cuenta?",
                                style: TextStyle(
                                  color: Color.fromRGBO(0, 50, 77, 1),
                                  fontSize: 12,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/register');
                                },
                                child: const Text(
                                  "Regístrate",
                                  style: TextStyle(
                                    color: Color.fromRGBO(57, 169, 0, 1),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
