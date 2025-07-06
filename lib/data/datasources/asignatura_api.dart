// lib/data/datasources/asignatura_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_gestion_academica/domain/entities/asignatura.dart';

class AsignaturaApi {
  final String baseUrl = 'http://localhost:8082/api/asignaturas';

  Future<List<Asignatura>> getAll() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Asignatura.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar asignaturas');
    }
  }

  Future<Asignatura> create(Asignatura asignatura) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(asignatura.toJson()..remove('id')),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Asignatura.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear asignatura');
    }
  }

  Future<Asignatura> update(Asignatura asignatura) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${asignatura.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(asignatura.toJson()),
    );
    if (response.statusCode == 200) {
      return Asignatura.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al actualizar asignatura');
    }
  }

  Future<void> delete(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Error al eliminar asignatura');
    }
  }
}