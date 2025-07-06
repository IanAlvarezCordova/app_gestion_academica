// lib/application/usecases/nota_usecase.dart
import 'package:app_gestion_academica/domain/entities/nota.dart';
import 'package:app_gestion_academica/data/repositories/nota_repository_impl.dart';

class NotaUseCases {
  final NotaRepositoryImpl repository;

  NotaUseCases(this.repository);

  Future<List<Nota>> getAll() => repository.getAll();
  Future<Nota> create(Nota nota) => repository.create(nota);
  Future<Nota> update(Nota nota) => repository.update(nota);
  Future<void> delete(int id) => repository.delete(id);
}