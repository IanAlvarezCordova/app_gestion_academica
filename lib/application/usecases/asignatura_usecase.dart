// lib/application/usecases/asignatura_usecase.dart
import 'package:app_gestion_academica/domain/entities/asignatura.dart';
import 'package:app_gestion_academica/data/repositories/asignatura_repository_impl.dart';

class AsignaturaUseCases {
  final AsignaturaRepositoryImpl repository;

  AsignaturaUseCases(this.repository);

  Future<List<Asignatura>> getAll() => repository.getAll();
  Future<Asignatura> create(Asignatura asignatura) => repository.create(asignatura);
  Future<Asignatura> update(Asignatura asignatura) => repository.update(asignatura);
  Future<void> delete(int id) => repository.delete(id);
}