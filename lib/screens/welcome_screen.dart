import 'package:flutter/material.dart';
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset('assets/icons/chat.png',
            height: 258,
            width: 246,
            fit: BoxFit.contain,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Text(
                  'MI ',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(57, 169, 0, 1)
                  ),
                ),
                Text(
                  'AYUDA ',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),Text(
                  'TICS ',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(57, 169, 0, 1)
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Regional Cauca',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                elevation: 2,
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromRGBO(57, 169, 0, 1),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Iniciar Sesión'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                 Navigator.pushReplacementNamed(context, '/register');
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
              child: const Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}