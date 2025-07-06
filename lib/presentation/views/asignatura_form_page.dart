// lib/presentation/views/asignatura_form_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_gestion_academica/domain/entities/asignatura.dart';
import 'package:app_gestion_academica/presentation/providers/asignatura_provider.dart';

class AsignaturaFormPage extends ConsumerStatefulWidget {
  final Asignatura? asignatura;
  const AsignaturaFormPage({this.asignatura, super.key});

  @override
  ConsumerState<AsignaturaFormPage> createState() => _AsignaturaFormPageState();
}

class _AsignaturaFormPageState extends ConsumerState<AsignaturaFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreCtrl;

  @override
  void initState() {
    super.initState();
    _nombreCtrl = TextEditingController(text: widget.asignatura?.nombre ?? '');
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (_formKey.currentState!.validate()) {
      final nuevaAsignatura = Asignatura(
        id: widget.asignatura?.id ?? 0,
        nombre: _nombreCtrl.text,
      );

      final notifier = ref.read(asignaturaProvider.notifier);
      try {
        if (widget.asignatura == null) {
          await notifier.addAsignatura(nuevaAsignatura);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Asignatura creada con éxito')),
          );
        } else {
          await notifier.updateAsignatura(nuevaAsignatura);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Asignatura actualizada con éxito')),
          );
        }
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.asignatura != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Asignatura' : 'Nueva Asignatura'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreCtrl,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _guardar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  isEditing ? 'Actualizar' : 'Crear',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}