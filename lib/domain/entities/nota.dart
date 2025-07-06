class Nota {
  final int id;
  final double calificacion;
  final int alumnoId;
  final int asignaturaId;
  final String descripcion;
  final DateTime? fecha;

  Nota({
    required this.id,
    required this.calificacion,
    required this.alumnoId,
    required this.asignaturaId,
    required this.descripcion,
    required this.fecha,
  });

  factory Nota.fromJson(Map<String, dynamic> json) {
    return Nota(
      id: json['id'],
      calificacion: json['calificacion'].toDouble(),
      alumnoId: json['alumnoId'],
      asignaturaId: json['asignaturaId'],
      descripcion: json['descripcion'] ?? '',
      fecha: json['fecha'] != null ? DateTime.parse(json['fecha']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'calificacion': calificacion,
      'alumnoId': alumnoId,
      'asignaturaId': asignaturaId,
      'descripcion': descripcion,
      'fecha': fecha?.toIso8601String(),
    };
  }
}
