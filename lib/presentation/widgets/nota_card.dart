// lib/presentation/widgets/nota_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_gestion_academica/domain/entities/nota.dart';
import 'package:app_gestion_academica/presentation/providers/nota_provider.dart';

class NotaCard extends ConsumerWidget {
  final Nota nota;
  final String alumnoNombre;
  final String alumnoApellido;
  final String asignaturaNombre;

  const NotaCard({
    required this.nota,
    required this.alumnoNombre,
    required this.alumnoApellido,
    required this.asignaturaNombre,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          child: Text(nota.calificacion.toString()[0]),
          backgroundColor: Colors.orange[100],
        ),
        title: Text('Calificación: ${nota.calificacion}'),
        subtitle: Text('Alumno: $alumnoNombre $alumnoApellido\nAsignatura: $asignaturaNombre'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                Navigator.pushNamed(context, '/nota_form', arguments: nota);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                ref.read(notaProvider.notifier).deleteNota(nota.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nota eliminada con éxito')),
                );
              },
            ),
          ],
        ),
        onTap: () {
          Navigator.pushNamed(context, '/nota_form', arguments: nota);
        },
      ),
    );
  }
}
