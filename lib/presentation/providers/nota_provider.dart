// lib/presentation/providers/nota_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_gestion_academica/domain/entities/nota.dart';
import 'package:app_gestion_academica/data/datasources/nota_api.dart';
import 'package:app_gestion_academica/data/repositories/nota_repository_impl.dart';
import 'package:app_gestion_academica/application/usecases/nota_usecase.dart';

final notaProvider = StateNotifierProvider<NotaNotifier, AsyncValue<List<Nota>>>((ref) {
  return NotaNotifier();
});

class NotaNotifier extends StateNotifier<AsyncValue<List<Nota>>> {
  final NotaUseCases useCases = NotaUseCases(NotaRepositoryImpl(NotaApi()));

  NotaNotifier() : super(const AsyncValue.loading()) {
    fetchNotas();
  }

  Future<void> fetchNotas() async {
    try {
      final notas = await useCases.getAll();
      state = AsyncValue.data(notas);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addNota(Nota nota) async {
    await useCases.create(nota);
    await fetchNotas();
  }

  Future<void> updateNota(Nota nota) async {
    await useCases.update(nota);
    await fetchNotas();
  }

  Future<void> deleteNota(int id) async {
    await useCases.delete(id);
    await fetchNotas();
  }
}