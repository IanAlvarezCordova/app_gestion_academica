// lib/presentation/providers/alumno_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_gestion_academica/domain/entities/alumno.dart';
import 'package:app_gestion_academica/data/datasources/alumno_api.dart';
import 'package:app_gestion_academica/data/repositories/alumno_repository_impl.dart';
import 'package:app_gestion_academica/application/usecases/alumno_usecase.dart';

final alumnoProvider = StateNotifierProvider<AlumnoNotifier, AsyncValue<List<Alumno>>>((ref) {
  return AlumnoNotifier();
});

class AlumnoNotifier extends StateNotifier<AsyncValue<List<Alumno>>> {
  final AlumnoUseCases useCases = AlumnoUseCases(AlumnoRepositoryImpl(AlumnoApi()));

  AlumnoNotifier() : super(const AsyncValue.loading()) {
    fetchAlumnos();
  }

  Future<void> fetchAlumnos() async {
    try {
      final alumnos = await useCases.getAll();
      state = AsyncValue.data(alumnos);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addAlumno(Alumno alumno) async {
    await useCases.create(alumno);
    await fetchAlumnos();
  }

  Future<void> updateAlumno(Alumno alumno) async {
    await useCases.update(alumno);
    await fetchAlumnos();
  }

  Future<void> deleteAlumno(int id) async {
    await useCases.delete(id);
    await fetchAlumnos();
  }
}