class TipoCaso {
  final String id;
  final String nombre;
  final String descripcion;

  TipoCaso({
    required this.id,
    required this.nombre,
    required this.descripcion,
  });

  // Factory constructor to create a TipoCaso instance from JSON
  factory TipoCaso.fromJson(Map<String, dynamic> json){
    return TipoCaso(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion']
    );
  }

  // Method to convert a TipoCaso instance to JSON
  Map<String, dynamic> toJson(){
     return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
    };
  }
}
