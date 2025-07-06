// lib/presentation/widgets/alumno_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_gestion_academica/domain/entities/alumno.dart';
import 'package:app_gestion_academica/presentation/providers/alumno_provider.dart';

class AlumnoCard extends ConsumerWidget {
  final Alumno alumno;

  const AlumnoCard({required this.alumno, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          child: Text(alumno.nombre[0]),
        ),
        title: Text('${alumno.nombre} ${alumno.apellido}'),
        subtitle: Text(alumno.email),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                Navigator.pushNamed(context, '/alumno_form', arguments: alumno);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                ref.read(alumnoProvider.notifier).deleteAlumno(alumno.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Alumno eliminado con éxito')),
                );
              },
            ),
          ],
        ),
        onTap: () {
          Navigator.pushNamed(context, '/alumno_form', arguments: alumno);
        },
      ),


    );

  }
}