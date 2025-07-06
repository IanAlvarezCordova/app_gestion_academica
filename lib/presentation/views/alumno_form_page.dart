// lib/presentation/views/alumno_form_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_gestion_academica/domain/entities/alumno.dart';
import 'package:app_gestion_academica/presentation/providers/alumno_provider.dart';

class AlumnoFormPage extends ConsumerStatefulWidget {
  final Alumno? alumno;
  const AlumnoFormPage({this.alumno, super.key});

  @override
  ConsumerState<AlumnoFormPage> createState() => _AlumnoFormPageState();
}

class _AlumnoFormPageState extends ConsumerState<AlumnoFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreCtrl;
  late TextEditingController _apellidoCtrl;
  late TextEditingController _emailCtrl;

  @override
  void initState() {
    super.initState();
    _nombreCtrl = TextEditingController(text: widget.alumno?.nombre ?? '');
    _apellidoCtrl = TextEditingController(text: widget.alumno?.apellido ?? '');
    _emailCtrl = TextEditingController(text: widget.alumno?.email ?? '');
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _apellidoCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (_formKey.currentState!.validate()) {
      final nuevoAlumno = Alumno(
        id: widget.alumno?.id ?? 0,
        nombre: _nombreCtrl.text,
        apellido: _apellidoCtrl.text,
        email: _emailCtrl.text,
      );

      final notifier = ref.read(alumnoProvider.notifier);
      try {
        if (widget.alumno == null) {
          await notifier.addAlumno(nuevoAlumno);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Alumno creado con éxito')),
          );
        } else {
          await notifier.updateAlumno(nuevoAlumno);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Alumno actualizado con éxito')),
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
    final isEditing = widget.alumno != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Alumno' : 'Nuevo Alumno'),
        backgroundColor: Colors.blue,
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
              const SizedBox(height: 16),
              TextFormField(
                controller: _apellidoCtrl,
                decoration: InputDecoration(
                  labelText: 'Apellido',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailCtrl,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                value!.isEmpty || !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)
                    ? 'Email inválido'
                    : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _guardar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
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
