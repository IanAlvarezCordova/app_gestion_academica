// lib/main.dart
import 'package:app_gestion_academica/presentation/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app_gestion_academica/presentation/views/alumno_list_page.dart';
import 'package:app_gestion_academica/presentation/views/alumno_form_page.dart';
import 'package:app_gestion_academica/presentation/views/asignatura_list_page.dart';
import 'package:app_gestion_academica/presentation/views/asignatura_form_page.dart';
import 'package:app_gestion_academica/presentation/views/nota_list_page.dart';
import 'package:app_gestion_academica/presentation/views/nota_form_page.dart';

import 'domain/entities/alumno.dart';
import 'domain/entities/asignatura.dart';
import 'domain/entities/nota.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión Académica',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.grey[100],
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const HomePage());

          case '/alumno_list':
            return MaterialPageRoute(builder: (_) => const AlumnoListPage());

          case '/alumno_form':
            final alumno = settings.arguments as Alumno?;
            return MaterialPageRoute(
              builder: (_) => AlumnoFormPage(alumno: alumno),
            );

          case '/asignatura_list':
            return MaterialPageRoute(builder: (_) => const AsignaturaListPage());

          case '/asignatura_form':
            final asignatura = settings.arguments as Asignatura?;
            return MaterialPageRoute(
              builder: (_) => AsignaturaFormPage(asignatura: asignatura),
            );

          case '/nota_list':
            return MaterialPageRoute(builder: (_) => const NotaListPage());

          case '/nota_form':
            final nota = settings.arguments as Nota?;
            return MaterialPageRoute(
              builder: (_) => NotaFormPage(nota: nota),
            );

          default:
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                body: Center(child: Text('Ruta no encontrada: ${settings.name}')),
              ),
            );
        }
      },
    );
  }
}
