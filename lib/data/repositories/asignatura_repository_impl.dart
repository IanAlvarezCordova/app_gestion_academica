// lib/data/repositories/asignatura_repository_impl.dart
import 'package:app_gestion_academica/domain/entities/asignatura.dart';
import 'package:app_gestion_academica/data/datasources/asignatura_api.dart';

abstract class AsignaturaRepository {
  Future<List<Asignatura>> getAll();
  Future<Asignatura> create(Asignatura asignatura);
  Future<Asignatura> update(Asignatura asignatura);
  Future<void> delete(int id);
}

class AsignaturaRepositoryImpl implements AsignaturaRepository {
  final AsignaturaApi api;

  AsignaturaRepositoryImpl(this.api);

  @override
  Future<List<Asignatura>> getAll() => api.getAll();

  @override
  Future<Asignatura> create(Asignatura asignatura) => api.create(asignatura);

  @override
  Future<Asignatura> update(Asignatura asignatura) => api.update(asignatura);

  @override
  Future<void> delete(int id) => api.delete(id);
}