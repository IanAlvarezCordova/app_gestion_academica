// lib/presentation/views/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_gestion_academica/presentation/providers/alumno_provider.dart';
import 'package:app_gestion_academica/presentation/providers/asignatura_provider.dart';
import 'package:app_gestion_academica/presentation/providers/nota_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alumnosState = ref.watch(alumnoProvider);
    final asignaturasState = ref.watch(asignaturaProvider);
    final notasState = ref.watch(notaProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión Académica'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: alumnosState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (alumnos) => asignaturasState.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (asignaturas) => notasState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (notas) {
                final promedioNotas = notas.isNotEmpty
                    ? (notas.fold<double>(0, (sum, nota) => sum + nota.calificacion) / notas.length).toStringAsFixed(2)
                    : '0.00';

                return GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildSummaryCard(
                      context,
                      title: 'Alumnos',
                      value: alumnos.length.toString(),
                      icon: Icons.person,
                      color: Colors.blue,
                      onTap: () => Navigator.pushNamed(context, '/alumno_list'),
                    ),
                    _buildSummaryCard(
                      context,
                      title: 'Asignaturas',
                      value: asignaturas.length.toString(),
                      icon: Icons.book,
                      color: Colors.green,
                      onTap: () => Navigator.pushNamed(context, '/asignatura_list'),
                    ),
                    _buildSummaryCard(
                      context,
                      title: 'Notas',
                      value: notas.length.toString(),
                      icon: Icons.grade,
                      color: Colors.orange,
                      onTap: () => Navigator.pushNamed(context, '/nota_list'),
                    ),
                    _buildSummaryCard(
                      context,
                      title: 'Promedio Notas',
                      value: promedioNotas,
                      icon: Icons.calculate,
                      color: Colors.purple,
                      onTap: () => Navigator.pushNamed(context, '/nota_list'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
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

  Widget _buildSummaryCard(
      BuildContext context, {
        required String title,
        required String value,
        required IconData icon,
        required Color color,
        required VoidCallback onTap,
      }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(fontSize: 24, color: color, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}