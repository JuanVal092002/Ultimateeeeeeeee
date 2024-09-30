import 'package:flutter/material.dart';
import 'package:mesa_servicio_ctpi/controllers/request_controller.dart';
import 'package:mesa_servicio_ctpi/widgets/appBar_widget.dart';
import 'package:mesa_servicio_ctpi/models/solicitud_model.dart'; // Asegúrate de importar el modelo

class InformeRequestScreen extends StatefulWidget {
  final String solicitudId;

  const InformeRequestScreen({super.key, required this.solicitudId});

  @override
  State<InformeRequestScreen> createState() => _InformeRequestScreenState();
}

class _InformeRequestScreenState extends State<InformeRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  late Future<Solicitud> solicitudFuture; // Aquí se almacenará el futuro que obtendrá los datos
  final RequestInformeController _requestController = RequestInformeController();

  @override
  void initState() {
    super.initState();
    solicitudFuture = _requestController.getInformeRequests(widget.solicitudId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppbarWidget(),
      ), // Se instancia el widget AppBarWidget
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 300), // Ajuste de padding
            child: Center(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(222, 217, 217, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50), // Ajuste de padding
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'SOLICITUD',
                            style: TextStyle(
                              color: Color.fromRGBO(57, 169, 0, 1),
                              fontSize: 35, // Aumentar el tamaño para mejor visibilidad
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          FutureBuilder<Solicitud>(
                            future: solicitudFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator()); // Indicador de carga
                              } else if (snapshot.hasError) {
                                print(snapshot.error);
                                return Center(child: Text('Error: ${snapshot.error}')); // Mostrar error
                              } else if (snapshot.hasData) {
                                final solicitud = snapshot.data!;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Center(
                                      child: Text(
                                        'Funcionario:',
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(0, 50, 77, 1),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    TextField(
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
                                        labelText: solicitud.usuario.nombre, // Mostrar el nombre del funcionario
                                        labelStyle: const TextStyle(
                                          color: Colors.black45,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16.0),
                                    const Center(
                                      child: Text(
                                        'Descripción:',
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(0, 50, 77, 1),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    TextField(
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
                                        labelText: solicitud.descripcion,
                                        labelStyle: const TextStyle(
                                          color: Colors.black45,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16.0),
                                    const Center(
                                      child: Text(
                                        'Fecha:',
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(0, 50, 77, 1),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    TextField(
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
                                        labelText: solicitud.fecha,
                                        labelStyle: const TextStyle(
                                          color: Colors.black45,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16.0),
                                    const Center(
                                      child: Text(
                                        'Estado:',
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(0, 50, 77, 1),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    TextField(
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
                                        labelText: solicitud.estado,
                                        labelStyle: const TextStyle(
                                          color: Colors.black45,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16.0),
                                    const Center(
                                      child: Text(
                                        'Ambiente:',
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(0, 50, 77, 1),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    TextField(
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
                                        labelText: solicitud.ambiente.nombre,
                                        labelStyle: const TextStyle(
                                          color: Colors.black45,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16.0),
                                    // Verificar si hay una foto y mostrarla
                                    if (solicitud.foto != null) ...[
                                      const Text(
                                        'Foto:',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromRGBO(0, 50, 77, 1),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Image.network(
                                        solicitud.foto!.url, // Asegúrate de tener esta propiedad en el modelo
                                        fit: BoxFit.cover,
                                      ),
                                    ] else ...[
                                      const Text(
                                        'No hay foto disponible.',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromRGBO(0, 50, 77, 1),
                                        ),
                                      ),
                                    ],
                                    const SizedBox(height: 30.0),
                                  ],
                                );
                              } else {
                                return const Center(child: Text('No se encontraron datos.'));
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
