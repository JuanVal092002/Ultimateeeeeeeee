import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ForgotModalWidget extends StatefulWidget {
  const ForgotModalWidget({super.key});

  @override
  State<ForgotModalWidget> createState() => _ForgotModalWidgetState();
}

class _ForgotModalWidgetState extends State<ForgotModalWidget> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _forgotPassword() async {
    final email = _emailController.text;
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa un correo electrónico')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse('https://backendnodeproyectomesaservicio.onrender.com/api/recuperarPassword');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'correo': email,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Correo de recuperación enviado')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
 Widget build(BuildContext context) {
  return AlertDialog(
    backgroundColor: const Color.fromRGBO(222, 217, 217, 1),
    content: SizedBox(
      width: MediaQuery.of(context).size.width * .7,
      height: MediaQuery.of(context).size.height * .2,
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              maxLines: null,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
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
                labelStyle: const TextStyle(
                  fontSize: 15,
                  color: Colors.black45,
                  fontWeight: FontWeight.w700,
                )
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _forgotPassword,
                    style: ElevatedButton.styleFrom(
                      elevation: 2,
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromRGBO(0, 50, 77, 1),
                      padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                child: const Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}