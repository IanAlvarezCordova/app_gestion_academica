// lib/presentation/widgets/nota_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_gestion_academica/domain/entities/nota.dart';
import 'package:app_gestion_academica/presentation/providers/nota_provider.dart';
import 'package:app_gestion_academica/presentation/views/nota_form_page.dart';

class NotaCard extends ConsumerWidget {
  final Nota nota;
  final String alumnoNombre;
  final String alumnoApellido;
  final String asignaturaNombre;

  const NotaCard({
    super.key,
    required this.nota,
    required this.alumnoNombre,
    required this.alumnoApellido,
    required this.asignaturaNombre,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fechaFormateada = nota.fecha != null
        ? DateFormat('yyyy-MM-dd').format(nota.fecha!)
        : 'Sin fecha';

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NotaFormPage(nota: nota),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Material(
          elevation: 1,
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título principal
                Row(
                  children: [
                    Icon(Icons.school, color: Colors.orange[800]),
                    const SizedBox(width: 8),
                    Text(
                      'Calificación: ${nota.calificacion}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[900],
                      ),
                    ),
                    const Spacer(),  // Esto empuja los botones de eliminar al final
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Mostrar el diálogo de confirmación antes de eliminar
                        _confirmarEliminacion(context, ref);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Detalles
                _buildInfoRow('Alumno', '$alumnoNombre $alumnoApellido'),
                _buildInfoRow('Asignatura', asignaturaNombre),
                if (nota.descripcion != null && nota.descripcion!.isNotEmpty)
                  _buildInfoRow('Descripción', nota.descripcion!),
                _buildInfoRow('Fecha', fechaFormateada),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black54),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Método para mostrar el diálogo de confirmación
  void _confirmarEliminacion(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¿Estás seguro?'),
          content: const Text('Esta acción no se puede deshacer.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo si el usuario cancela
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () {
                // Llamar al método deleteNota de notaProvider para eliminar la nota
                ref.read(notaProvider.notifier).deleteNota(nota.id);

                // Cerrar el diálogo y mostrar el SnackBar de confirmación
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nota eliminada con éxito')),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
