// lib/presentation/views/nota_list_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_gestion_academica/domain/entities/nota.dart';
import 'package:app_gestion_academica/domain/entities/alumno.dart';
import 'package:app_gestion_academica/domain/entities/asignatura.dart';
import 'package:app_gestion_academica/presentation/providers/nota_provider.dart';
import 'package:app_gestion_academica/presentation/providers/alumno_provider.dart';
import 'package:app_gestion_academica/presentation/providers/asignatura_provider.dart';
import 'package:app_gestion_academica/presentation/widgets/nota_card.dart';

class NotaListPage extends ConsumerWidget {
  const NotaListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notasState = ref.watch(notaProvider);
    final alumnosState = ref.watch(alumnoProvider);
    final asignaturasState = ref.watch(asignaturaProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notas por Asignatura'),
        backgroundColor: Colors.orange,
      ),
      body: notasState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (notas) => asignaturasState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (asignaturas) => alumnosState.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (alumnos) {
              // Agrupar notas por asignatura
              final notasPorAsignatura = <Asignatura, List<Nota>>{};
              for (var asignatura in asignaturas) {
                final notasAsignatura = notas
                    .where((nota) => nota.asignaturaId == asignatura.id)
                    .toList();

                // Ordenar las notas por nombre + apellido del alumno
                notasAsignatura.sort((a, b) {
                  final alumnoA = alumnos.firstWhere((al) => al.id == a.alumnoId);
                  final alumnoB = alumnos.firstWhere((al) => al.id == b.alumnoId);
                  final nombreCompletoA = '${alumnoA.nombre} ${alumnoA.apellido}'.toLowerCase();
                  final nombreCompletoB = '${alumnoB.nombre} ${alumnoB.apellido}'.toLowerCase();
                  return nombreCompletoA.compareTo(nombreCompletoB);
                });

                notasPorAsignatura[asignatura] = notasAsignatura;
              }

              return ListView.builder(
                itemCount: notasPorAsignatura.keys.length,
                itemBuilder: (context, index) {
                  final asignatura = notasPorAsignatura.keys.elementAt(index);
                  final notasAsignatura = notasPorAsignatura[asignatura]!;

                  return ExpansionTile(
                    leading: CircleAvatar(
                      child: Text(asignatura.nombre[0]),
                      backgroundColor: Colors.orange[100],
                    ),
                    title: Text(asignatura.nombre),
                    subtitle: Text('${notasAsignatura.length} notas'),
                    children: notasAsignatura.map((nota) {
                      final alumno = alumnos.firstWhere(
                            (a) => a.id == nota.alumnoId,
                        orElse: () => Alumno(id: 0, nombre: 'Desconocido', apellido: '', email: '' ),
                      );
                      return NotaCard(
                        nota: nota,
                        alumnoNombre: alumno.nombre,
                        alumnoApellido: alumno.apellido,
                        asignaturaNombre: asignatura.nombre,
                      );
                    }).toList(),
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/nota_form'),
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
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
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}