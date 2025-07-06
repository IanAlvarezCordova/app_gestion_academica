// lib/data/repositories/nota_repository_impl.dart
import 'package:app_gestion_academica/domain/entities/nota.dart';
import 'package:app_gestion_academica/data/datasources/nota_api.dart';

abstract class NotaRepository {
  Future<List<Nota>> getAll();
  Future<Nota> create(Nota nota);
  Future<Nota> update(Nota nota);
  Future<void> delete(int id);
}

class NotaRepositoryImpl implements NotaRepository {
  final NotaApi api;

  NotaRepositoryImpl(this.api);

  @override
  Future<List<Nota>> getAll() => api.getAll();

  @override
  Future<Nota> create(Nota nota) => api.create(nota);

  @override
  Future<Nota> update(Nota nota) => api.update(nota);

  @override
  Future<void> delete(int id) => api.delete(id);
}