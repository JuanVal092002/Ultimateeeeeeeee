import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mesa_servicio_ctpi/controllers/solution_controller.dart';
import 'package:mesa_servicio_ctpi/screens/home_tecnico_screen.dart';
import 'package:mesa_servicio_ctpi/widgets/appBar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormRequestScreen extends StatefulWidget {
    final String idSolicitud;
  const FormRequestScreen({super.key, required this.idSolicitud});

  @override
  State<FormRequestScreen> createState() => _FormRequestScreenState();
}

class _FormRequestScreenState extends State<FormRequestScreen> {
  final _descripcionController = TextEditingController();
  final List<String> _estados = ['pendiente', 'finalizado'];
  String? _selectedEstado;
  String?_tiposCaso;
  List<dynamic> _tiposDeCaso = [];
  bool _isLoadingTiposDeCaso = true;
  String _errorMessage = '';
  File? _fotoFile;
  final _formKey = GlobalKey<FormState>();
  final SolucionCasoController _solucionCasoController = SolucionCasoController();


  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchTiposDeCaso();
  }

  @override
  void dispose(){
    _descripcionController.dispose();
    super.dispose();
  }


  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _fetchTiposDeCaso() async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Token de autenticación no disponible');
      }

      final response = await http.get(
        Uri.parse('https://backendnodeproyectomesaservicio.onrender.com/api/tipoCaso'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _tiposDeCaso = data['data'];
          _isLoadingTiposDeCaso = false;
        });
      } else {
        setState(() {
          _isLoadingTiposDeCaso = false;
          _errorMessage = 'Error al obtener datos: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingTiposDeCaso = false;
        _errorMessage = 'Error al conectar con el servidor: $e';
      });
    }
  }

  Future<void> _seleccionarFoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _fotoFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _enviarSolucion() async {
  if (_formKey.currentState!.validate()) {
    try {
      final result = await _solucionCasoController.enviarSolucionCaso(
        idSolicitud: widget.idSolicitud, // ID de la solicitud pasado como parámetro
        descripcionSolucion: _descripcionController.text,
        tipoCaso: _tiposCaso!,
        tipoSolucion: _selectedEstado!,
        evidencia: _fotoFile != null ? XFile(_fotoFile!.path) : null,
      );

      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result)), // Mensaje de éxito
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al enviar la solución')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al enviar la solución: $e')),
      );
    }
  }
}
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: const PreferredSize(preferredSize: Size.fromHeight(100), child: AppbarWidget()), 
    body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 300),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              decoration: const BoxDecoration(
                color: Color.fromRGBO(222, 217, 217, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      'SOLUCION AL CASO',
                      style: TextStyle(
                        color: Color.fromRGBO(57, 169, 0, 1),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      controller: _descripcionController,
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
                        labelText: 'Descripción',
                        labelStyle: const TextStyle(
                          fontSize: 15,
                          color: Colors.black45,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese la descripción';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    _isLoadingTiposDeCaso
                        ? const CircularProgressIndicator()
                        : _errorMessage.isNotEmpty
                            ? Center(child: Text(_errorMessage))
                            : DropdownButtonFormField<String>(
                                value: _tiposCaso,
                                items: _tiposDeCaso.map<DropdownMenuItem<String>>((tipoCaso) {
                                  return DropdownMenuItem<String>(
                                    value: tipoCaso['_id'].toString(),
                                    child: Text(tipoCaso['nombre']),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _tiposCaso = value;
                                  });
                                },
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
                                  labelText: 'Tipo Caso',
                                  labelStyle: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor seleccione el tipo de caso';
                                  }
                                  return null;
                                },
                              ),
                    const SizedBox(height: 16.0),
                    DropdownButtonFormField<String>(
                      value: _selectedEstado,
                      items: _estados.map<DropdownMenuItem<String>>((estado) {
                        return DropdownMenuItem<String>(
                          value: estado,
                          child: Text(estado),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedEstado = value;
                        });
                      },
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
                        labelText: 'Estado Solución',
                        labelStyle: const TextStyle(
                          fontSize: 15,
                          color: Colors.black45,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor seleccione un estado';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    _fotoFile != null
                        ? Image.file(
                            _fotoFile!,
                            width: 200,
                            height: 200,
                          )
                        : Container(),
                    ElevatedButton(
                      onPressed: _seleccionarFoto,
                      style: ElevatedButton.styleFrom(
                        elevation: 2,
                        foregroundColor: Colors.white,
                        backgroundColor: const Color.fromRGBO(57, 169, 0, 1),
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        textStyle: const TextStyle(
                          color: Colors.black45,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      child: const Text('Imagen'),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: ()  {
                      // Asegúrate de que todos los datos están listos para ser enviados
                      print(widget.idSolicitud);
                      print(_selectedEstado);
                      print(_tiposCaso);
                      print(_descripcionController.text);  
                      _enviarSolucion();
                      // Redirige al usuario a la pantalla anterior
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeTechnicianScreen()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 2,
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromRGBO(0, 50, 77, 1),
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle: const TextStyle(
                        color: Colors.black45,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    child: const Text('Dar Solución'),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
