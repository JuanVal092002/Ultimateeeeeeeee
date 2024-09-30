class Ambiente {
  final String nombre;
  final bool activo;

  Ambiente({
    required this.nombre,
    this.activo = true,
  });

  /// Método para crear una instancia de `Ambiente` a partir de un JSON
  factory Ambiente.fromJson(Map<String, dynamic> json) {
    return Ambiente(
      nombre: json['nombre'] as String,
      activo: json['activo'] as bool? ?? true,
    );
  }

  /// Método para convertir la instancia de `Ambiente` en un Map de JSON
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'activo': activo,
    };
  }

  /// Método copyWith para crear una copia modificada de la instancia de `Ambiente`
  Ambiente copyWith({
    String? nombre,
    bool? activo,
  }) {
    return Ambiente(
      nombre: nombre ?? this.nombre,
      activo: activo ?? this.activo,
    );
  }

  @override
  String toString() {
    return 'Ambiente(nombre: $nombre, activo: $activo)';
  }
}
