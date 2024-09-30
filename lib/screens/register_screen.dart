import 'package:flutter/material.dart';
import 'package:mesa_servicio_ctpi/controllers/register_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureText = true;
  bool _obscureTextConfirm = true;
  String? _selectedRole;

  final RegisterUsers _registerController = RegisterUsers();

  final List<String> _roles = [ 'tecnico', 'funcionario'];

  Future<void> _register() async {
  if (_formKey.currentState?.validate() ?? false) {
    final nombre = _nombreController.text;
    final correo = _correoController.text;
    final rol = _selectedRole ?? '';
    final telefono = _telefonoController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    final result = await _registerController.registerUser(
      nombre: nombre,
      correo: correo,
      rol: rol,
      telefono: telefono,
      password: password,
      confirmPassword: confirmPassword,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result['message'])),
    );

    if (result['success']) {
      // Limpiar los campos del formulario
      _nombreController.clear();
      _correoController.clear();
      _telefonoController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      setState(() {
        _selectedRole = null; // Limpiar el rol seleccionado
      });

      // Aquí puedes navegar a otra pantalla si lo deseas
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
              padding: const EdgeInsets.only(top: 540),
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
                            'REGISTRO',
                            style: TextStyle(
                              color: Color.fromRGBO(57, 169, 0, 1),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextFormField(
                            controller: _nombreController,
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
                              labelText: 'Nombre',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese su nombre';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _correoController,
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
                              labelText: 'Correo',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese su correo';
                              } else if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value)) {
                                return 'Ingrese un correo electrónico válido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _selectedRole,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color.fromRGBO(255, 254, 254, 1),
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
                              labelText: 'Rol',
                            ),
                            items: _roles.map((role) {
                              return DropdownMenuItem<String>(
                                value: role,
                                child: Text(role),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedRole = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor seleccione su rol';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _telefonoController,
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
                              labelText: 'Teléfono',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese su teléfono';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscureText,
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
                              labelText: 'Contraseña',
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese una contraseña';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureTextConfirm,
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
                              labelText: 'Confirmar contraseña',
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureTextConfirm = !_obscureTextConfirm;
                                  });
                                },
                                child: Icon(
                                  _obscureTextConfirm
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: const Color.fromRGBO(53, 74, 106, 1),
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor confirme su contraseña';
                              }
                              if (value != _passwordController.text) {
                                return 'Las contraseñas no coinciden';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: () async {
                              print(_nombreController.text);
                              print(_confirmPasswordController.text);
                              print(_selectedRole);
                              print(_correoController.text);
                              print(_passwordController.text);
                              print(_correoController.text);
                              await _register();
                            },
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
                            child: const Text('Registrar'),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "¿Tienes una cuenta?",
                                style: TextStyle(
                                  color: Color.fromRGBO(0, 50, 77, 1),
                                  fontSize: 11,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(context, '/login');
                                },
                                child: const Text(
                                  'Iniciar sesión',
                                  style: TextStyle(
                                    color: Color.fromRGBO(57, 169, 0, 1),
                                    fontSize: 11,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Color.fromRGBO(57, 169, 0, 1),
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
