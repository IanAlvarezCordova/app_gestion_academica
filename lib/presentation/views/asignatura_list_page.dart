// lib/presentation/views/asignatura_list_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_gestion_academica/domain/entities/asignatura.dart';
import 'package:app_gestion_academica/presentation/providers/asignatura_provider.dart';
import 'package:app_gestion_academica/presentation/widgets/asignatura_card.dart';

class AsignaturaListPage extends ConsumerWidget {
  const AsignaturaListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(asignaturaProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Asignaturas'),
        backgroundColor: Colors.green,
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (asignaturas) => ListView.builder(
          itemCount: asignaturas.length,
          itemBuilder: (context, index) {
            final asignatura = asignaturas[index];
            return AsignaturaCard(asignatura: asignatura);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/asignatura_form'),
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/alumno_list');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/asignatura_list');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/nota_list');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Alumnos'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Asignaturas'),
          BottomNavigationBarItem(icon: Icon(Icons.grade), label: 'Notas'),
        ],
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}