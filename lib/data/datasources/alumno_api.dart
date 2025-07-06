// lib/data/datasources/alumno_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_gestion_academica/domain/entities/alumno.dart';

class AlumnoApi {
  final String baseUrl = 'https://gestion-academica-backend-td8y.onrender.com/api/alumnos';

  Future<List<Alumno>> getAll() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Alumno.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar alumnos');
    }
  }

  Future<Alumno> create(Alumno alumno) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(alumno.toJson()..remove('id')),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Alumno.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear alumno');
    }
  }

  Future<Alumno> update(Alumno alumno) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${alumno.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(alumno.toJson()),
    );
    if (response.statusCode == 200) {
      return Alumno.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al actualizar alumno');
    }
  }

  Future<void> delete(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Error al eliminar alumno');
    }
  }
}