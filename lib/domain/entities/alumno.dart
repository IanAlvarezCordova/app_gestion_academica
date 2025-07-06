// lib/domain/entities/alumno.dart
class Alumno {
  final int id;
  final String nombre;
  final String apellido;
  final String email;

  Alumno({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.email,
  });

  factory Alumno.fromJson(Map<String, dynamic> json) {
    return Alumno(
      id: json['id'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'email': email,
    };
  }
}