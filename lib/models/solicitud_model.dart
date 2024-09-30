import 'package:mesa_servicio_ctpi/models/ambiente_model.dart';
import 'package:mesa_servicio_ctpi/models/storage_model.dart';
import 'package:mesa_servicio_ctpi/models/usuario_model.dart';

class Solicitud {
  final String id;
  final String descripcion;
  final String fecha;
  final String estado;
  final Usuario usuario;
  final Ambiente ambiente;
  final Usuario tecnico;
  final String codigoCaso;
  final String telefono;
  final Storage? foto;

  Solicitud({
    required this.id,
    required this.descripcion,
    required this.fecha,
    required this.estado,
    required this.usuario,
    required this.ambiente,
    required this.tecnico,
    required this.codigoCaso,
    required this.telefono,
    this.foto,
  });

  factory Solicitud.fromJson(Map<String, dynamic> json) {
    return Solicitud(
      id: json['_id'] ?? '', // Asegúrate de usar el campo correcto
      descripcion: json['descripcion'] ?? '',
      fecha: json['fecha'] ?? '',
      estado: json['estado'] ?? '',
      usuario: Usuario.fromJson(json['usuario'] ?? {}), // Manejo de nulos
      ambiente: Ambiente.fromJson(json['ambiente'] ?? {}), // Manejo de nulos
      tecnico: Usuario.fromJson(json['tecnico'] ?? {}), // Manejo de nulos
      codigoCaso: json['codigoCaso'] ?? '',
      telefono: json['telefono'] ?? '',
      foto: json['foto'] != null ? Storage.fromJson(json['foto']) : null, // Asegúrate de manejar el null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id, // Asegúrate de usar el campo correcto
      'descripcion': descripcion,
      'fecha': fecha,
      'estado': estado,
      'usuario': usuario.toJson(), // Asegúrate de que el modelo Usuario tenga toJson
      'ambiente': ambiente.toJson(), // Asegúrate de que el modelo Ambiente tenga toJson
      'tecnico': tecnico.toJson(), // Asegúrate de que el modelo Usuario tenga toJson
      'telefono': telefono,
      'codigoCaso': codigoCaso,
      'foto': foto?.toJson(), // Manejo seguro del posible null
    };
  }
}
