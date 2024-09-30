import 'package:flutter/material.dart';
import 'package:mesa_servicio_ctpi/controllers/request_controller.dart';
import 'package:mesa_servicio_ctpi/screens/form_request_screen.dart';
import 'package:mesa_servicio_ctpi/screens/informe_request_screen.dart';
import 'package:mesa_servicio_ctpi/widgets/appBar_widget.dart';

class HomeTechnicianScreen extends StatefulWidget {
  const HomeTechnicianScreen({super.key});

  @override
  State<HomeTechnicianScreen> createState() => _HomeTechnicianScreenState();
}

class _HomeTechnicianScreenState extends State<HomeTechnicianScreen> {
  String? _error;
  final RequestAssignedController _controller = RequestAssignedController();
  late Future<List<dynamic>> _assignedRequests;

  @override
  void initState() {
    super.initState();
    _assignedRequests = _loadAssignedRequests();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _assignedRequests = _loadAssignedRequests();
  }

  // Obtener solicitudes asignadas del backend
  Future<List<dynamic>> _loadAssignedRequests() async {
    try {
      List<dynamic> solicitudes = await _controller.getAssignedRequests();
      return solicitudes;
    } catch (e) {
      setState(() {
        _error = 'Error al cargar las solicitudes: $e';
      });
      return []; // Retornamos una lista vacía en caso de error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100), 
        child: AppbarWidget(),
      ), // Se instancia el widget AppBarWidget
      body: FutureBuilder<List<dynamic>>(
        future: _assignedRequests,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No hay solicitudes asignadas',
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          } else {
            // Construir la lista de solicitudes
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final request = snapshot.data![index];
                final estado = request['estado'] ?? 'Sin estado';
                return Card(
                  key: ValueKey(request['_id']),
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Esquinas redondeadas
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => InformeRequestScreen(solicitudId: request['_id'])),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(0), // Eliminar padding del botón
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  request['descripcion'] ?? 'Sin descripción',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(0, 50, 77, 1), 
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  request['usuario']?['nombre'] ?? 'Sin nombre',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color:  Color.fromRGBO(57, 169, 0, 1),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  request['fecha'] ?? 'Sin fecha',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                   estado,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromRGBO(0, 50, 77, 1),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                if (estado == 'asignado' || estado == 'pendiente')
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context, 
                                        MaterialPageRoute(builder: (context) => FormRequestScreen(idSolicitud: request['_id'])),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 2,
                                      foregroundColor: Colors.white,
                                      backgroundColor: estado == 'pendiente' 
                                          ? const Color.fromRGBO(186, 16, 8, 1)
                                          : const Color.fromRGBO(57, 169, 0, 1),
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      textStyle: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    child: const Text('Dar Solución'),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(222, 217, 217, 1),
        onPressed: () {
          setState(() {
            _assignedRequests = _loadAssignedRequests();
          });
        },
        child: const Icon(Icons.refresh, color: Color.fromRGBO(0, 50, 77, 1)),
      ),
    );
  }
}
