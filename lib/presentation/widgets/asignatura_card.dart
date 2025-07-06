// lib/presentation/widgets/asignatura_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_gestion_academica/domain/entities/asignatura.dart';
import 'package:app_gestion_academica/presentation/providers/asignatura_provider.dart';

class AsignaturaCard extends ConsumerWidget {
  final Asignatura asignatura;

  const AsignaturaCard({required this.asignatura, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          child: Text(asignatura.nombre[0]),
        ),
        title: Text(asignatura.nombre),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                Navigator.pushNamed(context, '/asignatura_form', arguments: asignatura);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                ref.read(asignaturaProvider.notifier).deleteAsignatura(asignatura.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Asignatura eliminada con éxito')),
                );
              },
            ),
          ],
        ),
        onTap: () {
          Navigator.pushNamed(context, '/asignatura_form', arguments: asignatura);
        },
      ),
    );
  }
}