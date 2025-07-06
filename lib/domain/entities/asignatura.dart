// lib/domain/entities/asignatura.dart
class Asignatura {
  final int id;
  final String nombre;

  Asignatura({
    required this.id,
    required this.nombre,
  });

  factory Asignatura.fromJson(Map<String, dynamic> json) {
    return Asignatura(
      id: json['id'],
      nombre: json['nombre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
    };
  }
}