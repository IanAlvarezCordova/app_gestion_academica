// lib/presentation/views/alumno_list_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_gestion_academica/domain/entities/alumno.dart';
import 'package:app_gestion_academica/presentation/providers/alumno_provider.dart';
import 'package:app_gestion_academica/presentation/widgets/alumno_card.dart';

class AlumnoListPage extends ConsumerWidget {
  const AlumnoListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(alumnoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alumnos'),
        backgroundColor: Colors.blue,
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (alumnos) => ListView.builder(
          itemCount: alumnos.length,
          itemBuilder: (context, index) {
            final alumno = alumnos[index];
            return AlumnoCard(alumno: alumno);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/alumno_form'),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
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
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}