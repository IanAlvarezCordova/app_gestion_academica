// lib/application/usecases/alumno_usecase.dart
import 'package:app_gestion_academica/domain/entities/alumno.dart';
import 'package:app_gestion_academica/data/repositories/alumno_repository_impl.dart';

class AlumnoUseCases {
  final AlumnoRepositoryImpl repository;

  AlumnoUseCases(this.repository);

  Future<List<Alumno>> getAll() => repository.getAll();
  Future<Alumno> create(Alumno alumno) => repository.create(alumno);
  Future<Alumno> update(Alumno alumno) => repository.update(alumno);
  Future<void> delete(int id) => repository.delete(id);
}