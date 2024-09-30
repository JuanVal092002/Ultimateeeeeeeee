import 'package:mesa_servicio_ctpi/models/solicitud_model.dart';
import 'package:mesa_servicio_ctpi/models/storage_model.dart';
import 'package:mesa_servicio_ctpi/models/tipocaso_model.dart';

class SolucionCaso {
  final String id;
  final Solicitud solicitud; // ID de la solicitud
  final String descripcionSolucion;
  final TipoCaso tipoCaso; // ID del tipo de caso
  final String tipoSolucion;
  final Storage? evidencia; // ID de la evidencia (opcional)
  
  SolucionCaso({
    required this.id,
    required this.solicitud,
    required this.descripcionSolucion,
    required this.tipoCaso,
    required this.tipoSolucion,
    this.evidencia,
  });

  // Factory constructor to create a SolucionCaso instance from JSON
  factory SolucionCaso.fromJson(Map<String, dynamic> json) {
    return SolucionCaso(
      id:json ['id'], 
      solicitud: json['solicitud'] , 
      descripcionSolucion: json ['descripcionSolucion'], 
      tipoCaso: json ['tipoCaso'], 
      tipoSolucion: json['tipoSolucion']);
  }

  // Method to convert a SolucionCaso instance to JSON
  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'solicitud': solicitud,
      'descripcion': descripcionSolucion,
      'tipoCaso': tipoCaso,
      'tipoSolucion': tipoSolucion,
    };
  }
}


