// lib/presentation/providers/asignatura_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_gestion_academica/domain/entities/asignatura.dart';
import 'package:app_gestion_academica/data/datasources/asignatura_api.dart';
import 'package:app_gestion_academica/data/repositories/asignatura_repository_impl.dart';
import 'package:app_gestion_academica/application/usecases/asignatura_usecase.dart';

final asignaturaProvider = StateNotifierProvider<AsignaturaNotifier, AsyncValue<List<Asignatura>>>((ref) {
  return AsignaturaNotifier();
});

class AsignaturaNotifier extends StateNotifier<AsyncValue<List<Asignatura>>> {
  final AsignaturaUseCases useCases = AsignaturaUseCases(AsignaturaRepositoryImpl(AsignaturaApi()));

  AsignaturaNotifier() : super(const AsyncValue.loading()) {
    fetchAsignaturas();
  }

  Future<void> fetchAsignaturas() async {
    try {
      final asignaturas = await useCases.getAll();
      state = AsyncValue.data(asignaturas);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addAsignatura(Asignatura asignatura) async {
    await useCases.create(asignatura);
    await fetchAsignaturas();
  }

  Future<void> updateAsignatura(Asignatura asignatura) async {
    await useCases.update(asignatura);
    await fetchAsignaturas();
  }

  Future<void> deleteAsignatura(int id) async {
    await useCases.delete(id);
    await fetchAsignaturas();
  }
}