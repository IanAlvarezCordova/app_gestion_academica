// lib/presentation/views/nota_form_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_gestion_academica/domain/entities/nota.dart';
import 'package:app_gestion_academica/domain/entities/alumno.dart';
import 'package:app_gestion_academica/domain/entities/asignatura.dart';
import 'package:app_gestion_academica/presentation/providers/nota_provider.dart';
import 'package:app_gestion_academica/presentation/providers/alumno_provider.dart';
import 'package:app_gestion_academica/presentation/providers/asignatura_provider.dart';
import 'package:intl/intl.dart';

class NotaFormPage extends ConsumerStatefulWidget {
  final Nota? nota;
  const NotaFormPage({this.nota, super.key});

  @override
  ConsumerState<NotaFormPage> createState() => _NotaFormPageState();
}

class _NotaFormPageState extends ConsumerState<NotaFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _calificacionCtrl;
  late TextEditingController _descripcionCtrl;
  late TextEditingController _fechaCtrl;

  int? _selectedAlumnoId;
  int? _selectedAsignaturaId;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _calificacionCtrl = TextEditingController(text: widget.nota?.calificacion?.toString() ?? '');
    _descripcionCtrl = TextEditingController(text: widget.nota?.descripcion ?? '');
    _selectedAlumnoId = widget.nota?.alumnoId;
    _selectedAsignaturaId = widget.nota?.asignaturaId;
    _selectedDate = widget.nota?.fecha;
    _fechaCtrl = TextEditingController(
      text: _selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : '',
    );
  }

  @override
  void dispose() {
    _calificacionCtrl.dispose();
    _descripcionCtrl.dispose();
    _fechaCtrl.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _fechaCtrl.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _guardar() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedAlumnoId == null || _selectedAsignaturaId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Seleccione un alumno y una asignatura')),
        );
        return;
      }

      final nuevaNota = Nota(
        id: widget.nota?.id ?? 0,
        calificacion: double.parse(_calificacionCtrl.text),
        alumnoId: _selectedAlumnoId!,
        asignaturaId: _selectedAsignaturaId!,
        descripcion: _descripcionCtrl.text,
        fecha: _selectedDate,
      );

      final notifier = ref.read(notaProvider.notifier);
      try {
        if (widget.nota == null) {
          await notifier.addNota(nuevaNota);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nota creada con éxito')),
          );
        } else {
          await notifier.updateNota(nuevaNota);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nota actualizada con éxito')),
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
    final isEditing = widget.nota != null;
    final alumnosState = ref.watch(alumnoProvider);
    final asignaturasState = ref.watch(asignaturaProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Nota' : 'Nueva Nota'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _calificacionCtrl,
                decoration: InputDecoration(
                  labelText: 'Calificación',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Campo requerido';
                  final numValue = double.tryParse(value);
                  if (numValue == null || numValue < 0 || numValue > 20) {
                    return 'Debe ser un número entre 0 y 20';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              alumnosState.when(
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text('Error al cargar alumnos: $e'),
                data: (alumnos) => DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: 'Alumno',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  value: _selectedAlumnoId,
                  items: alumnos.map((alumno) {
                    return DropdownMenuItem<int>(
                      value: alumno.id,
                      child: Text('${alumno.nombre} ${alumno.apellido}'),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedAlumnoId = value),
                  validator: (value) => value == null ? 'Seleccione un alumno' : null,
                ),
              ),
              const SizedBox(height: 16),
              asignaturasState.when(
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text('Error al cargar asignaturas: $e'),
                data: (asignaturas) => DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: 'Asignatura',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  value: _selectedAsignaturaId,
                  items: asignaturas.map((asignatura) {
                    return DropdownMenuItem<int>(
                      value: asignatura.id,
                      child: Text(asignatura.nombre),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedAsignaturaId = value),
                  validator: (value) => value == null ? 'Seleccione una asignatura' : null,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descripcionCtrl,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fechaCtrl,
                decoration: InputDecoration(
                  labelText: 'Fecha',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: _seleccionarFecha,
                validator: (value) => value == null || value.isEmpty ? 'Seleccione una fecha' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _guardar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
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
