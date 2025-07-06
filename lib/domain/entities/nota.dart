// lib/domain/entities/nota.dart
class Nota {
  final int id;
  final double calificacion;
  final int alumnoId;
  final int asignaturaId;

  Nota({
    required this.id,
    required this.calificacion,
    required this.alumnoId,
    required this.asignaturaId,
  });

  factory Nota.fromJson(Map<String, dynamic> json) {
    return Nota(
      id: json['id'],
      calificacion: json['calificacion'].toDouble(),
      alumnoId: json['alumnoId'],
      asignaturaId: json['asignaturaId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'calificacion': calificacion,
      'alumnoId': alumnoId,
      'asignaturaId': asignaturaId,
    };
  }
}