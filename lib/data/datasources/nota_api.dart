// lib/data/datasources/nota_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_gestion_academica/domain/entities/nota.dart';

class NotaApi {
  final String baseUrl = 'https://gestion-academica-backend-td8y.onrender.com/api/notas';

  Future<List<Nota>> getAll() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Nota.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar notas');
    }
  }

  Future<Nota> create(Nota nota) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(nota.toJson()..remove('id')),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Nota.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear nota');
    }
  }

  Future<Nota> update(Nota nota) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${nota.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(nota.toJson()),
    );
    if (response.statusCode == 200) {
      return Nota.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al actualizar nota');
    }
  }

  Future<void> delete(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Error al eliminar nota');
    }
  }
}