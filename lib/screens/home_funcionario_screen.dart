import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mesa_servicio_ctpi/widgets/appBar_widget.dart';
import 'package:mesa_servicio_ctpi/controllers/request_controller.dart'; // Asegúrate de importar tu controlador

class HomeOfficerScreen extends StatefulWidget {
  const HomeOfficerScreen({super.key});

  @override
  State<HomeOfficerScreen> createState() => _HomeOfficerScreenState();
}

class _HomeOfficerScreenState extends State<HomeOfficerScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedAmbiente;
  List<dynamic> _ambientes = [];
  bool _isLoadingAmbientes = true;
  String _errorMessage = '';
  final _descripcionController = TextEditingController();
  final _telefonoController = TextEditingController();
  File? _fotoFile;

  final RequestController _requestController = RequestController(); // Instanciar el controlador

  @override
  void initState() {
    super.initState();
    _fetchAmbientes();
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  void dispose(){
    _descripcionController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }


  Future<void> _fetchAmbientes() async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Token de autenticación no disponible');
      }
      final response = await http.get(
        Uri.parse('https://backendnodeproyectomesaservicio.onrender.com/api/ambienteFormacion'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _ambientes = data['data'];
          _isLoadingAmbientes = false;
        });
        } else {
        setState(() {
          _isLoadingAmbientes = false;
          _errorMessage = 'Error al obtener datos: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingAmbientes = false;
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

  Future<void> _registrarSolicitud() async {
    if (_formKey.currentState!.validate()) {
      try {
       final result = await _requestController.crearSolicitud(
          ambiente: _selectedAmbiente!,
          descripcion: _descripcionController.text,
          telefono: _telefonoController.text,
          foto: _fotoFile != null ? XFile(_fotoFile!.path) : null,
        );
        if (result != null) {
        setState(() {
          _selectedAmbiente = null;
          _descripcionController.clear();
          _telefonoController.clear();
          _fotoFile = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result)), // Mensaje de éxito
        );
      }  else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al crear la solicitud')),
        );
        }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear la solicitud: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(preferredSize: Size.fromHeight(100), child: AppbarWidget()),
      body: Center(
        child: SingleChildScrollView(
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
              child:Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      'SOLICITUD A REGISTRAR',
                      style: TextStyle(
                        color: Color.fromRGBO(57, 169, 0, 1),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    _isLoadingAmbientes ?
                    const CircularProgressIndicator():
                    _errorMessage.isNotEmpty ? Center(
                      child: Text(_errorMessage),
                    ):
                    DropdownButtonFormField<String>(
                      value: _selectedAmbiente,
                      items: _ambientes.map<DropdownMenuItem<String>>((ambiente) {
                        return DropdownMenuItem<String>(
                          value: ambiente['_id'].toString(),
                          child: Text(ambiente['nombre']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedAmbiente = value;
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
                        labelText: 'Ambiente',
                        labelStyle: const TextStyle(
                          fontSize: 15,
                          color: Colors.black45,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor seleccione el ambiente';
                              }
                              return null;
                            },
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
                     TextFormField(
                      maxLines: null,
                      keyboardType: TextInputType.number,
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
                        labelText: 'Telefono',
                        labelStyle: const TextStyle(
                          fontSize: 15,
                          color: Colors.black45,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese su telefono';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                      _fotoFile != null
                          ? Image.file(
                              _fotoFile!,
                              width: 200,
                              height: 200,
                            )
                          : Container(),
                    const SizedBox(height: 16),
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
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed:() {
                          print(_selectedAmbiente);
                          print(_descripcionController.text);
                          print(_telefonoController.text);
                          _registrarSolicitud();
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
                        child: const Text('Registrar Solicitud'),
                      ),
                    ]
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
