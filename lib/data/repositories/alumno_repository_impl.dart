// lib/data/repositories/alumno_repository_impl.dart
import 'package:app_gestion_academica/domain/entities/alumno.dart';
import 'package:app_gestion_academica/data/datasources/alumno_api.dart';

abstract class AlumnoRepository {
  Future<List<Alumno>> getAll();
  Future<Alumno> create(Alumno alumno);
  Future<Alumno> update(Alumno alumno);
  Future<void> delete(int id);
}

class AlumnoRepositoryImpl implements AlumnoRepository {
  final AlumnoApi api;

  AlumnoRepositoryImpl(this.api);

  @override
  Future<List<Alumno>> getAll() => api.getAll();

  @override
  Future<Alumno> create(Alumno alumno) => api.create(alumno);

  @override
  Future<Alumno> update(Alumno alumno) => api.update(alumno);

  @override
  Future<void> delete(int id) => api.delete(id);
}